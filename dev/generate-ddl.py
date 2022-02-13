#!/usr/bin/env python3
from stringcase import pascalcase as upper_camel_case
import oci
import jinja2

oci_resources = {
    "identity_compartment": oci.identity.models.Compartment().swagger_types,
    "core_instance": oci.core.models.Instance().swagger_types,
    "core_vnic_attachment": oci.core.models.VnicAttachment().swagger_types,
    "core_vnic": oci.core.models.Vnic().swagger_types,
    "core_subnet": oci.core.models.Subnet().swagger_types,
    "core_image": oci.core.models.Image().swagger_types,
    "core_vcn": oci.core.models.Vcn().swagger_types,
    "core_subnet": oci.core.models.Subnet().swagger_types,
}

# return the postgres type from the swagger type
def pg_type(t):
    return {
        "bool": "boolean",
        "datetime": "timestamp",
        "int": "integer",
        "str": "text",
        "list[str]": "text[]",
    }.get(t.lower(), "JSON")


#
# template all the things
#
template = jinja2.Template(open("templates/pg-ddl.j2.sql").read())


with open("sql/pg-ddl.sql", "w+") as file:
    file.write(
        template.render(
            resources=oci_resources,
            # functions
            convert_type=pg_type,
        )
    )
