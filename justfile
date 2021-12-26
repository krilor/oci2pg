
# connect to the postgres database
connect:
  psql -d oci -U oci

# generate table ddl
ddl:
  ./dev/generate-ddl.py

# insert postgres ddl
up:
  cat sql/*.sql | psql -U oci -d oci

# bring up a postgres container
pg:
  docker run --rm -d -p 5432:5432 -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=oci postgres:14-alpine
