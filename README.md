# Database Migrations

This repository contains database migrations for preparing a ready-to-use database structure to collect data from data extractors.

## Local Set Up 

To collect data locally, we need to have a running database instance.

1. In the `scripts` directory, create a copy of the dev.env file and save it with the name .env. You can use the command below:

    ```shell
    cp dev.env .env 
    ```

2. Set all empty environment variables in the .env file.
3. Change directory to the main repository directory.
4. Run a database instance in a Docker container by running the command below:

    ```shell
    docker compose -f docker-compose.database.yaml up
    ```

5. If your local database is running, execute the `local_migration.sh` script from `scripts` directory to run all migrations against the database.
6. Now, your local database is ready to collect data from data extractors.