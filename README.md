# oci2pg

The sole purpose of this project is to establish the capability to dump Oracle Cloud Infrastructure (OCI) config to a Postgres database.
Once it's in the database the data can be used for whatever purpose you want.

* Ad-hoc queries
* Local rest API, e.g. with [PostgREST](https://postgrest.org/en/stable/)

## Why would you want to dump OCI config in a Postgres database?

The project is still just an idea of exploring the usefulness of of such a capability. It was spawned by a need to do ad-hoc queries on OCI config to answer questions or produce overviews and inventories.
While OCI CLI and SDK allows you to do, but it's not as ergonomic as a good'ol SQL querey (to me, at least).

## Give it a spin

This project uses the [just](https://github.com/casey/just) command runner.

```bash
# spin up a postgres docker container
make pg

# add tables and views
make up

# run the oci2pg tool
OCI2PG_PASSWORD=123 ./oci2pg.py
```

## Requirements

Made with python 3.8.10 - it will probably work with newer versions of Python 3.

Python requirements are defined in `requirements.txt`.
Install dependencies:

```bash
pip install -r requirements.txt
```
