
# Basics
terraform {
}

# Oracle Cloud
provider "oci" {
  # loads config from ~/.oci/config
}

locals {
  _oci_config  = file("~/.oci/config")
  tenancy_ocid = regex("(?im)^tenancy\\s?=\\s?(.*?)$", local._oci_config)[0]
}

#
## User, group and policies
#
resource "oci_identity_user" "oci2pg" {
  compartment_id = local.tenancy_ocid
  description    = "User for oci2pg"
  name           = "oci2pg"
}

resource "oci_identity_group" "oci2pg" {
  compartment_id = local.tenancy_ocid
  description    = "Group for oci2pg"
  name           = "oci2pg"
}

resource "oci_identity_user_group_membership" "oci2pg" {
  group_id = oci_identity_group.oci2pg.id
  user_id  = oci_identity_user.oci2pg.id
}

resource "oci_identity_user_capabilities_management" "oci2pg" {
  user_id = oci_identity_user.oci2pg.id

  can_use_api_keys             = true
  can_use_auth_tokens          = false
  can_use_console_password     = false
  can_use_customer_secret_keys = false
  can_use_smtp_credentials     = false
}

resource "tls_private_key" "oci2pg" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_identity_api_key" "oci2pg" {
  key_value = tls_private_key.oci2pg.public_key_pem
  user_id   = oci_identity_user.oci2pg.id
}

resource "oci_identity_policy" "oci2pg" {
  compartment_id = local.tenancy_ocid
  description    = "Policies for oci2pg"
  name           = "oci2pg"
  statements = [
    # Stream
    "Allow group ${oci_identity_group.oci2pg.name} to use stream-pull in tenancy where target.streampool.id = '${oci_streaming_stream_pool.oci2pg.id}'",
    # Read Access
    "Allow group ${oci_identity_group.oci2pg.name} to read instance-family in tenancy",
    "Allow group ${oci_identity_group.oci2pg.name} to read virtual-network-family in tenancy",
  ]
}

#
## Local user config
#
resource "local_file" "oci2pg_api_key" {
  content              = tls_private_key.oci2pg.private_key_pem
  filename             = pathexpand("~/.oci2pg/api_key.pem")
  file_permission      = "0750"
  directory_permission = "0600"
}

resource "local_file" "ociconfig" {
  content = <<-EOF
      [DEFAULT]
      tenancy = ${local.tenancy_ocid}
      user = ${oci_identity_user.oci2pg.id}
      key_file = ${pathexpand("~/.oci2pg/api_key.pem")}
      fingerprint = ${oci_identity_api_key.oci2pg.fingerprint}
      region = eu-frankfurt-1
      EOF

  # FIXME hardcoded region
  filename             = pathexpand("~/.oci2pg/config")
  file_permission      = "0750"
  directory_permission = "0640"
}

#
## Stream
#

resource "oci_streaming_stream_pool" "oci2pg" {
  compartment_id = local.tenancy_ocid
  name           = "oci2pg"
}

resource "oci_streaming_stream" "oci2pg" {
  name               = "oci2pg"
  partitions         = 1
  retention_in_hours = 24 # 24-168h
  stream_pool_id     = oci_streaming_stream_pool.oci2pg.id
}

#
## Events
#
resource "oci_events_rule" "oci2pg" {
  description = "oci2pg"

  actions {
    actions {
      description = "oci2pg Stream"
      action_type = "OSS" # Oracle Streaming Service
      is_enabled  = true

      stream_id = oci_streaming_stream.oci2pg.id
    }
  }
  compartment_id = local.tenancy_ocid

  condition    = "{}" # FIXME - this matches all the things!
  display_name = "oci2pg"
  is_enabled   = true
}
