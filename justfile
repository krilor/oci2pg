
# connect to the postgres database
connect:
  psql -h localhost -p 5432 -d oci -U oci

# generate table ddl
ddl:
  ./dev/generate-ddl.py

# insert postgres ddl
up:
  cat sql/*.sql | psql -U oci -d oci

# bring up a postgres container
pg:
  docker run --name oci2pg --rm -d -p 5432:5432 -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=oci postgres:14-alpine

# stop pg
stop:
  docker stop oci2pg

# inspect schema with atlas
atlas-inspect:
  atlas schema inspect -d "postgres://oci:123@localhost:5432/oci?sslmode=disable" > atlas/schema.hcl

atlas-up:
  atlas schema apply -d "postgres://oci:123@localhost:5432/oci?sslmode=disable" --file atlas/schema.hcl

# unit test
test:
  python3 -m unittest discover -p '*_test.py' -v

# format all-the-code
fmt:
  black .
  cd terraform && terraform fmt
