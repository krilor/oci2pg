
-- identity_compartment

CREATE TABLE IF NOT EXISTS identity_compartment (
  compartment_id text, -- str
  defined_tags JSON, -- dict(str, dict(str, object))
  description text, -- str
  freeform_tags JSON, -- dict(str, str)
  id text PRIMARY KEY, -- str
  inactive_status integer, -- int
  is_accessible boolean, -- bool
  lifecycle_state text, -- str
  name text, -- str
  time_created timestamp -- datetime
);

-- core_instance

CREATE TABLE IF NOT EXISTS core_instance (
  agent_config JSON, -- InstanceAgentConfig
  availability_config JSON, -- InstanceAvailabilityConfig
  availability_domain text, -- str
  capacity_reservation_id text, -- str
  compartment_id text, -- str
  dedicated_vm_host_id text, -- str
  defined_tags JSON, -- dict(str, dict(str, object))
  display_name text, -- str
  extended_metadata JSON, -- dict(str, object)
  fault_domain text, -- str
  freeform_tags JSON, -- dict(str, str)
  id text PRIMARY KEY, -- str
  image_id text, -- str
  instance_options JSON, -- InstanceOptions
  ipxe_script text, -- str
  launch_mode text, -- str
  launch_options JSON, -- LaunchOptions
  lifecycle_state text, -- str
  metadata JSON, -- dict(str, str)
  platform_config JSON, -- PlatformConfig
  preemptible_instance_config JSON, -- PreemptibleInstanceConfigDetails
  region text, -- str
  shape text, -- str
  shape_config JSON, -- InstanceShapeConfig
  source_details JSON, -- InstanceSourceDetails
  system_tags JSON, -- dict(str, dict(str, object))
  time_created timestamp, -- datetime
  time_maintenance_reboot_due timestamp -- datetime
);

-- core_vnic_attachment

CREATE TABLE IF NOT EXISTS core_vnic_attachment (
  availability_domain text, -- str
  compartment_id text, -- str
  display_name text, -- str
  id text PRIMARY KEY, -- str
  instance_id text, -- str
  lifecycle_state text, -- str
  nic_index integer, -- int
  subnet_id text, -- str
  time_created timestamp, -- datetime
  vlan_id text, -- str
  vlan_tag integer, -- int
  vnic_id text -- str
);

-- core_vnic

CREATE TABLE IF NOT EXISTS core_vnic (
  availability_domain text, -- str
  compartment_id text, -- str
  defined_tags JSON, -- dict(str, dict(str, object))
  display_name text, -- str
  freeform_tags JSON, -- dict(str, str)
  hostname_label text, -- str
  id text PRIMARY KEY, -- str
  is_primary boolean, -- bool
  lifecycle_state text, -- str
  mac_address text, -- str
  nsg_ids text[], -- list[str]
  private_ip text, -- str
  public_ip text, -- str
  skip_source_dest_check boolean, -- bool
  subnet_id text, -- str
  time_created timestamp, -- datetime
  vlan_id text -- str
);

-- core_subnet

CREATE TABLE IF NOT EXISTS core_subnet (
  availability_domain text, -- str
  cidr_block text, -- str
  compartment_id text, -- str
  defined_tags JSON, -- dict(str, dict(str, object))
  dhcp_options_id text, -- str
  display_name text, -- str
  dns_label text, -- str
  freeform_tags JSON, -- dict(str, str)
  id text PRIMARY KEY, -- str
  ipv6_cidr_block text, -- str
  ipv6_virtual_router_ip text, -- str
  lifecycle_state text, -- str
  prohibit_internet_ingress boolean, -- bool
  prohibit_public_ip_on_vnic boolean, -- bool
  route_table_id text, -- str
  security_list_ids text[], -- list[str]
  subnet_domain_name text, -- str
  time_created timestamp, -- datetime
  vcn_id text, -- str
  virtual_router_ip text, -- str
  virtual_router_mac text -- str
);

-- core_image

CREATE TABLE IF NOT EXISTS core_image (
  agent_features JSON, -- InstanceAgentFeatures
  base_image_id text, -- str
  billable_size_in_gbs integer, -- int
  compartment_id text, -- str
  create_image_allowed boolean, -- bool
  defined_tags JSON, -- dict(str, dict(str, object))
  display_name text, -- str
  freeform_tags JSON, -- dict(str, str)
  id text PRIMARY KEY, -- str
  launch_mode text, -- str
  launch_options JSON, -- LaunchOptions
  lifecycle_state text, -- str
  listing_type text, -- str
  operating_system text, -- str
  operating_system_version text, -- str
  size_in_mbs integer, -- int
  time_created timestamp -- datetime
);

-- core_vcn

CREATE TABLE IF NOT EXISTS core_vcn (
  cidr_block text, -- str
  cidr_blocks text[], -- list[str]
  compartment_id text, -- str
  default_dhcp_options_id text, -- str
  default_route_table_id text, -- str
  default_security_list_id text, -- str
  defined_tags JSON, -- dict(str, dict(str, object))
  display_name text, -- str
  dns_label text, -- str
  freeform_tags JSON, -- dict(str, str)
  id text PRIMARY KEY, -- str
  ipv6_cidr_blocks text[], -- list[str]
  lifecycle_state text, -- str
  time_created timestamp, -- datetime
  vcn_domain_name text -- str
);
