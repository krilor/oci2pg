table "core_image" {
  schema = schema.public
  column "agent_features" {
    null = true
    type = json
  }
  column "base_image_id" {
    null = true
    type = text
  }
  column "billable_size_in_gbs" {
    null = true
    type = integer
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "create_image_allowed" {
    null = true
    type = boolean
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "display_name" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "id" {
    null = false
    type = text
  }
  column "launch_mode" {
    null = true
    type = text
  }
  column "launch_options" {
    null = true
    type = json
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "listing_type" {
    null = true
    type = text
  }
  column "operating_system" {
    null = true
    type = text
  }
  column "operating_system_version" {
    null = true
    type = text
  }
  column "size_in_mbs" {
    null = true
    type = integer
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  primary_key {
    columns = [table.core_image.column.id]
  }
}
table "core_instance" {
  schema = schema.public
  column "agent_config" {
    null = true
    type = json
  }
  column "availability_config" {
    null = true
    type = json
  }
  column "availability_domain" {
    null = true
    type = text
  }
  column "capacity_reservation_id" {
    null = true
    type = text
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "dedicated_vm_host_id" {
    null = true
    type = text
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "display_name" {
    null = true
    type = text
  }
  column "extended_metadata" {
    null = true
    type = json
  }
  column "fault_domain" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "id" {
    null = false
    type = text
  }
  column "image_id" {
    null = true
    type = text
  }
  column "instance_options" {
    null = true
    type = json
  }
  column "ipxe_script" {
    null = true
    type = text
  }
  column "launch_mode" {
    null = true
    type = text
  }
  column "launch_options" {
    null = true
    type = json
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "metadata" {
    null = true
    type = json
  }
  column "platform_config" {
    null = true
    type = json
  }
  column "preemptible_instance_config" {
    null = true
    type = json
  }
  column "region" {
    null = true
    type = text
  }
  column "shape" {
    null = true
    type = text
  }
  column "shape_config" {
    null = true
    type = json
  }
  column "source_details" {
    null = true
    type = json
  }
  column "system_tags" {
    null = true
    type = json
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  column "time_maintenance_reboot_due" {
    null = true
    type = timestamp_without_time_zone
  }
  primary_key {
    columns = [table.core_instance.column.id]
  }
}
table "core_subnet" {
  schema = schema.public
  column "availability_domain" {
    null = true
    type = text
  }
  column "cidr_block" {
    null = true
    type = text
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "dhcp_options_id" {
    null = true
    type = text
  }
  column "display_name" {
    null = true
    type = text
  }
  column "dns_label" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "id" {
    null = false
    type = text
  }
  column "ipv6_cidr_block" {
    null = true
    type = text
  }
  column "ipv6_virtual_router_ip" {
    null = true
    type = text
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "prohibit_internet_ingress" {
    null = true
    type = boolean
  }
  column "prohibit_public_ip_on_vnic" {
    null = true
    type = boolean
  }
  column "route_table_id" {
    null = true
    type = text
  }
  column "security_list_ids" {
    null = true
    type = sql("text[]")
  }
  column "subnet_domain_name" {
    null = true
    type = text
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  column "vcn_id" {
    null = true
    type = text
  }
  column "virtual_router_ip" {
    null = true
    type = text
  }
  column "virtual_router_mac" {
    null = true
    type = text
  }
  primary_key {
    columns = [table.core_subnet.column.id]
  }
}
table "core_vcn" {
  schema = schema.public
  column "cidr_block" {
    null = true
    type = text
  }
  column "cidr_blocks" {
    null = true
    type = sql("text[]")
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "default_dhcp_options_id" {
    null = true
    type = text
  }
  column "default_route_table_id" {
    null = true
    type = text
  }
  column "default_security_list_id" {
    null = true
    type = text
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "display_name" {
    null = true
    type = text
  }
  column "dns_label" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "id" {
    null = false
    type = text
  }
  column "ipv6_cidr_blocks" {
    null = true
    type = sql("text[]")
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  column "vcn_domain_name" {
    null = true
    type = text
  }
  primary_key {
    columns = [table.core_vcn.column.id]
  }
}
table "core_vnic" {
  schema = schema.public
  column "availability_domain" {
    null = true
    type = text
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "display_name" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "hostname_label" {
    null = true
    type = text
  }
  column "id" {
    null = false
    type = text
  }
  column "is_primary" {
    null = true
    type = boolean
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "mac_address" {
    null = true
    type = text
  }
  column "nsg_ids" {
    null = true
    type = sql("text[]")
  }
  column "private_ip" {
    null = true
    type = text
  }
  column "public_ip" {
    null = true
    type = text
  }
  column "skip_source_dest_check" {
    null = true
    type = boolean
  }
  column "subnet_id" {
    null = true
    type = text
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  column "vlan_id" {
    null = true
    type = text
  }
  primary_key {
    columns = [table.core_vnic.column.id]
  }
}
table "core_vnic_attachment" {
  schema = schema.public
  column "availability_domain" {
    null = true
    type = text
  }
  column "compartment_id" {
    null = true
    type = text
  }
  column "display_name" {
    null = true
    type = text
  }
  column "id" {
    null = false
    type = text
  }
  column "instance_id" {
    null = true
    type = text
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "nic_index" {
    null = true
    type = integer
  }
  column "subnet_id" {
    null = true
    type = text
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  column "vlan_id" {
    null = true
    type = text
  }
  column "vlan_tag" {
    null = true
    type = integer
  }
  column "vnic_id" {
    null = true
    type = text
  }
  primary_key {
    columns = [table.core_vnic_attachment.column.id]
  }
}
table "identity_compartment" {
  schema = schema.public
  column "compartment_id" {
    null = true
    type = text
  }
  column "defined_tags" {
    null = true
    type = json
  }
  column "description" {
    null = true
    type = text
  }
  column "freeform_tags" {
    null = true
    type = json
  }
  column "id" {
    null = false
    type = text
  }
  column "inactive_status" {
    null = true
    type = integer
  }
  column "is_accessible" {
    null = true
    type = boolean
  }
  column "lifecycle_state" {
    null = true
    type = text
  }
  column "name" {
    null = true
    type = text
  }
  column "time_created" {
    null = true
    type = timestamp_without_time_zone
  }
  primary_key {
    columns = [table.identity_compartment.column.id]
  }
}
schema "public" {
}
