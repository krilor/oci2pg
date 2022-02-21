from .db import *
import logging
import argparse
import oci

import os
import time
import json
import base64

from dotenv import load_dotenv

load_dotenv()

from .db import DB

version = "0.0.1"


def bulk() -> None:
    logging.info("Starting oci2pg version %s" % version)
    # oci.config.from_file falls back to OCI_CONFIG_FILE env var if default location does not exist.
    # we want to give the env var precedence, so we need to specify it in the call
    config = oci.config.from_file(
        os.getenv("OCI_CONFIG_FILE", oci.config.DEFAULT_LOCATION)
    )

    logging.info("User: %s" % config)

    # clients
    identity = oci.identity.IdentityClient(config)
    compute = oci.core.ComputeClient(config)
    network = oci.core.VirtualNetworkClient(config)

    db: DB = DB()

    compartments = identity.list_compartments(
        config["tenancy"], compartment_id_in_subtree=True
    )
    logging.info("bulk dumping compartments")
    for compartment in compartments.data:
        db.upsert("identity_compartment", compartment)

        logging.info("bulk dumping instances and their images")
        instances = compute.list_instances(compartment.id)
        if len(instances.data) > 0:
            for instance in instances.data:
                image = compute.get_image(instance.image_id)
                db.upsert("core_image", image.data)
                db.upsert("core_instance", instance)

        logging.info("bulk dumping vnic and attachment")
        vnic_attachments = compute.list_vnic_attachments(compartment.id)
        if len(vnic_attachments.data) > 0:
            for vnic_attachment in vnic_attachments.data:
                vnic = network.get_vnic(vnic_attachment.vnic_id)
                db.upsert("core_vnic", vnic.data)
                db.upsert("core_vnic_attachment", vnic_attachment)

        logging.info("bulk dumping vcn")
        vcns = network.list_vcns(compartment.id)
        if len(vcns.data) > 0:
            for vcn in vcns.data:
                db.upsert("core_vcn", vcn)

        logging.info("bulk dumping subnet")
        subnets = network.list_subnets(compartment.id)
        if len(subnets.data) > 0:
            for subnet in subnets.data:
                db.upsert("core_subnet", subnet)


def update_instance(config: Dict[str, Any], id: str) -> None:
    client = oci.core.ComputeClient(config)
    response = client.get_instance(id)
    db = DB()
    db.upsert("core_instance", response.data)


def get_cursor_by_group(
    sc: oci.streaming.StreamClient, sid: str, group_name: str, instance_name: str
) -> str:
    print(
        " Creating a cursor for group {}, instance {}".format(group_name, instance_name)
    )
    cursor_details = oci.streaming.models.CreateGroupCursorDetails(
        group_name=group_name,
        instance_name=instance_name,
        type=oci.streaming.models.CreateGroupCursorDetails.TYPE_TRIM_HORIZON,
        commit_on_get=True,
    )
    response = sc.create_group_cursor(sid, cursor_details)
    return response.data.value


def sync() -> None:
    # oci.config.from_file falls back to OCI_CONFIG_FILE env var if default location does not exist.
    # we want to give the env var precedence, so we need to specify it in the call
    oci_config = oci.config.from_file(
        os.getenv("OCI_CONFIG_FILE", oci.config.DEFAULT_LOCATION)
    )

    service_endpoint = os.getenv("OCI_STREAM_SERVICE_ENDPOINT")
    stream_id = os.getenv("OCI_STREAM_ID", "")

    stream_client = oci.streaming.StreamClient(
        oci_config, service_endpoint=service_endpoint
    )
    cursor = get_cursor_by_group(
        stream_client, stream_id, "example-group", "example-instance-1"
    )

    message_limit = 10

    while True:
        response = stream_client.get_messages(stream_id, cursor, limit=message_limit)

        num_recieved_messages = len(response.data)
        logging.info("Read {} messages".format(num_recieved_messages))

        for message in response.data:
            event = json.loads(base64.b64decode(message.value.encode()).decode())
            event_type = event["eventType"]
            if event_type == "com.oraclecloud.computeapi.updateinstance":
                resource_id = event["data"]["resourceId"]
                logging.info(
                    "Got {} event for resourceId {}".format(event_type, resource_id)
                )
                update_instance(oci_config, resource_id)

        if num_recieved_messages == message_limit:
            logging.debug("Got a lot of messages. Getting more in 1 seconds.")
            time.sleep(1)
        else:
            logging.debug("Message queue empty, waiting 10 seconds.")
            time.sleep(10)

        cursor = response.headers["opc-next-cursor"]


def main() -> None:

    log_levels = {
        "warning": logging.WARNING,
        "info": logging.INFO,
        "debug": logging.DEBUG,
    }
    parser = argparse.ArgumentParser(description="Sync OCI resources to postgres.")
    parser.add_argument(
        "processes",
        metavar="PROCESS",
        type=str,
        nargs="+",
        choices=["bulk", "stream"],
        help="the command to run: sync, stream",
    )
    parser.add_argument(
        "--log",
        "-log",
        "-l",
        default="warning",
        choices=log_levels.keys(),
        help="log level. Default: warning",
    )

    args = parser.parse_args()

    logging.basicConfig(
        format="%(levelname)s %(asctime)s %(message)s", level=log_levels[args.log]
    )

    try:
        if "bulk" in args.processes:
            bulk()
        if "stream" in args.processes:
            sync()

    except KeyboardInterrupt:
        logging.warn("Recieved Keyboard Interrupt!")
    finally:
        DB().close()
