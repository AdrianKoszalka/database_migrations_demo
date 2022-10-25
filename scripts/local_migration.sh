#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | xargs)
else
  echo "File .env doesn't exist"
  exit 1
fi

SCHEMA="youtube_data"

docker run --rm -v "${PWD%/*}/migrations":/liquibase/changelog liquibase/liquibase:4.17 \
  --url="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?currentSchema=$SCHEMA" \
  --changeLogFile=../liquibase/changelog/migrations_changelog.yaml \
  --username=$POSTGRES_USER --password=$POSTGRES_PASSWORD update