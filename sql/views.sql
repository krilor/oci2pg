CREATE OR REPLACE VIEW oci_inventory_v AS
SELECT
  i.id AS instance_id,
  i.display_name,
  v.private_ip,
  v.public_ip,
  img.operating_system,
  img.operating_system_version
FROM
  core_instance i
  INNER JOIN core_vnic_attachment va ON i.id = va.instance_id
  INNER JOIN core_vnic v ON va.vnic_id = v.id AND v.is_primary
  INNER JOIN core_image img on i.image_id = img.id;
