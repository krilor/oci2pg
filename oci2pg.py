#!/usr/bin/env python3

# environment
import os
from dotenv import load_dotenv
load_dotenv()


import logging

import oci

import psycopg2
import psycopg2.extras
psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)

version = '0.0.1'

def main():
  # logging
  logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.INFO)
  logging.info("Starting oci2pg version %s" % version)
  # oci.config.from_file falls back to OCI_CONFIG_FILE env var if default location does not exist.
  # we want to give the env var precedence, so we need to specify it in the call
  config = oci.config.from_file(os.getenv("OCI_CONFIG_FILE", oci.config.DEFAULT_LOCATION))

  logging.info("User: %s" % config)

  # clients
  identity = oci.identity.IdentityClient(config)
  compute = oci.core.ComputeClient(config)
  network = oci.core.VirtualNetworkClient(config)

  conn = psycopg2.connect(
    dbname=os.getenv("OCI2PG_DBNAME", "oci"),
    user=os.getenv("OCI2PG_USER", "oci"),
    password=os.getenv('OCI2PG_PASSWORD'),
    host=os.getenv("OCI2PG_HOST", "localhost"),
    port=os.getenv("OCI2PG_PORT", 5432)
  )

  # insert a resource
  def insert(conn, table, resource):
    logging.info("Insert %s - %s" % (table, getattr(resource, 'display_name', getattr(resource, 'name', getattr(resource, 'id')))))
    cur = conn.cursor()
    columns=sorted(resource.swagger_types)
    values=tuple(oci.util.to_dict(getattr(resource,column)) for column in columns)
    statement="INSERT into %s ( %s ) VALUES ( %s ) ON CONFLICT (id) DO NOTHING" % ( table, ",".join(columns), ",".join(["%s" for i in range(len(columns))]) )
    cur.execute(statement,values)
    conn.commit()

  compartments = identity.list_compartments(config["tenancy"], compartment_id_in_subtree=True)
  logging.info("bulk dumping compartments")
  for compartment in compartments.data:
    insert(conn, 'identity_compartment', compartment)

    logging.info("bulk dumping instances and their images")
    instances = compute.list_instances(compartment.id)
    if len(instances.data) > 0:
      for instance in instances.data:
        image = compute.get_image(instance.image_id)
        insert(conn, 'core_image', image.data)
        insert(conn, 'core_instance', instance)

    logging.info("bulk dumping vnic and attachment")
    vnic_attachments = compute.list_vnic_attachments(compartment.id)
    if len(vnic_attachments.data) > 0:
      for vnic_attachment in vnic_attachments.data:
        vnic = network.get_vnic(vnic_attachment.vnic_id)
        insert(conn, 'core_vnic', vnic.data)
        insert(conn, 'core_vnic_attachment', vnic_attachment)

    logging.info("bulk dumping vcn")
    vcns = network.list_vcns(compartment.id)
    if len(vcns.data) > 0:
      for vcn in vcns.data:
        insert(conn, 'core_vcn', vcn)

    logging.info("bulk dumping subnet")
    subnets = network.list_subnets(compartment.id)
    if len(subnets.data) > 0:
        for subnet in subnets.data:
          insert(conn, 'core_subnet', subnet)

  conn.close()


if __name__ == "__main__":
  main()
