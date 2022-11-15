#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | xargs)
else
  echo "File .env doesn't exist"
  exit 1
fi

find ../migrations/changesets/* -prune -type d | while IFS= read -r d; do
    if [[ $(basename "$d") == 'single_migrations' ]]
    then
      echo -e "\nSingle migrations are running."

      docker run --rm -v "${PWD%/*}/migrations":/liquibase/changelog liquibase/liquibase:4.17 \
        --url="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB" \
        --changeLogFile=../liquibase/changelog/migrations_changelog.yaml \
        --username=$POSTGRES_USER --password=$POSTGRES_PASSWORD update

    else
      SCHEMA="$(basename "$d")"
      echo -e "\nMigrations for schema ${SCHEMA} are running."
      echo -e "databaseChangeLog:\n  - includeAll:\n      path: changesets/${SCHEMA}/" > ../migrations/schema_migrations_changelog.yaml

      docker run --rm -v "${PWD%/*}/migrations":/liquibase/changelog liquibase/liquibase:4.17 \
        --url="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?currentSchema=$SCHEMA" \
        --changeLogFile=../liquibase/changelog/schema_migrations_changelog.yaml \
        --username=$POSTGRES_USER --password=$POSTGRES_PASSWORD update

      rm ../migrations/schema_migrations_changelog.yaml
      echo -e "Successfully run migrations for schema ${SCHEMA}."
    fi
done