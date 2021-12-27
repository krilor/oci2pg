#!/usr/bin/env python3

# environment
import os
from dotenv import load_dotenv
load_dotenv()

import oci
# oci.config.from_file falls back to OCI_CONFIG_FILE env var if default location does not exist.
# we want to give the env var precedence, so we need to specify it in the call
config = oci.config.from_file(os.getenv("OCI_CONFIG_FILE", oci.config.DEFAULT_LOCATION))

# clients
identity = oci.identity.IdentityClient(config)
compute = oci.core.ComputeClient(config)
network = oci.core.VirtualNetworkClient(config)

import psycopg2
import psycopg2.extras
psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)

conn = psycopg2.connect(
  dbname=os.getenv("OCI2PG_DBNAME", "oci"),
  user=os.getenv("OCI2PG_USER", "oci"),
  password=os.getenv('OCI2PG_PASSWORD'),
  host=os.getenv("OCI2PG_HOST", "localhost"),
  port=os.getenv("OCI2PG_PORT", 5432)
  )

# insert a resource
def insert(conn, table, resource):
  cur = conn.cursor()
  columns=sorted(resource.swagger_types)
  values=tuple(oci.util.to_dict(getattr(resource,column)) for column in columns)
  statement="INSERT into %s ( %s ) VALUES ( %s ) ON CONFLICT (id) DO NOTHING" % ( table, ",".join(columns), ",".join(["%s" for i in range(len(columns))]) )
  cur.execute(statement,values)
  conn.commit()


compartments = identity.list_compartments(config["tenancy"], compartment_id_in_subtree=True)
for compartment in compartments.data:
  insert(conn, 'identity_compartment', compartment)

  # instances and their image
  instances = compute.list_instances(compartment.id)
  if len(instances.data) > 0:
    for instance in instances.data:
      image = compute.get_image(instance.image_id)
      insert(conn, 'core_image', image.data)
      insert(conn, 'core_instance', instance)

  # vnic and attachment
  vnic_attachments = compute.list_vnic_attachments(compartment.id)
  if len(vnic_attachments.data) > 0:
    for vnic_attachment in vnic_attachments.data:
      vnic = network.get_vnic(vnic_attachment.vnic_id)
      insert(conn, 'core_vnic', vnic.data)
      insert(conn, 'core_vnic_attachment', vnic_attachment)

  # vcn
  vcns = network.list_vcns(compartment.id)
  if len(vcns.data) > 0:
    for vcn in vcns.data:
      insert(conn, 'core_vcn', vcn)

  # subnet
  subnets = network.list_subnets(compartment.id)
  if len(subnets.data) > 0:
      for subnet in subnets.data:
        insert(conn, 'core_subnet', subnet)

conn.close()
