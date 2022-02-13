from .singleton import Singleton

import psycopg2
import psycopg2.extras

psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)

import os
import logging

from oci.util import to_dict


class DB(metaclass=Singleton):

    __state = {}

    def __init__(self):

        self.__dict__ = self.__state

        if not hasattr(self, "conn"):
            self.conn = psycopg2.connect(
                dbname=os.getenv("OCI2PG_DBNAME", "oci"),
                user=os.getenv("OCI2PG_USER", "oci"),
                password=os.getenv("OCI2PG_PASSWORD"),
                host=os.getenv("OCI2PG_HOST", "localhost"),
                port=os.getenv("OCI2PG_PORT", 5432),
            )
            self.conn.autocommit = True

    def upsert(self, table, resource):
        logging.info(
            "Insert %s - %s"
            % (
                table,
                getattr(
                    resource,
                    "display_name",
                    getattr(resource, "name", getattr(resource, "id")),
                ),
            )
        )

        with self.conn.cursor() as cur:

            columns = sorted(resource.swagger_types)
            values = tuple(to_dict(getattr(resource, column)) for column in columns)
            statement = (
                "INSERT into %s ( %s ) VALUES ( %s ) ON CONFLICT (id) DO NOTHING"
                % (
                    table,
                    ",".join(columns),
                    ",".join(["%s" for i in range(len(columns))]),
                )
            )

            cur.execute(statement, values)

        return

    def close(self):
        self.conn.close()
        delattr(self, "conn")
