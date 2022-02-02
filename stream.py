#!/usr/bin/env python3

# https://docs.oracle.com/en-us/iaas/Content/Events/Reference/eventsproducers.htm
import oci
import time
import json

from base64 import b64decode

import os
from dotenv import load_dotenv
load_dotenv()

def get_cursor_by_group(sc, sid, group_name, instance_name):
    print(" Creating a cursor for group {}, instance {}".format(group_name, instance_name))
    cursor_details = oci.streaming.models.CreateGroupCursorDetails(group_name=group_name, instance_name=instance_name,
                                                                   type=oci.streaming.models.
                                                                   CreateGroupCursorDetails.TYPE_TRIM_HORIZON,
                                                                   commit_on_get=True)
    response = sc.create_group_cursor(sid, cursor_details)
    return response.data.value

def simple_message_loop(client, stream_id, initial_cursor):
    cursor = initial_cursor
    while True:
        response = client.get_messages(stream_id, cursor, limit=10)

        print(" Read {} messages".format(len(response.data)))
        for message in response.data:
            event = json.loads(b64decode(message.value.encode()).decode())
            if event["eventType"] == "com.oraclecloud.computeapi.updateinstance":
              id = event["data"]["resourceId"]
              print("event" + id)

        time.sleep(10)

        cursor = response.headers["opc-next-cursor"]


config = oci.config.from_file(os.getenv("OCI_CONFIG_FILE", oci.config.DEFAULT_LOCATION))

service_endpoint = os.getenv("OCI_STREAM_SERVICE_ENDPOINT")
stream_id = os.getenv("OCI_STREAM_ID")

stream_client = oci.streaming.StreamClient(config, service_endpoint=service_endpoint)
group_cursor = get_cursor_by_group(stream_client, stream_id, "example-group", "example-instance-1")

simple_message_loop(stream_client, stream_id, group_cursor)
