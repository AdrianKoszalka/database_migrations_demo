# Database Migrations

This repository contains database migrations for preparing ready to use DB structure to collect data from `data_extractors`.

## Local Set Up 

To collect data locale we need to have running database instance.

1. In directory `scripts` make a copy of file dev.env and save it with name .env. You can use command below:

    ```shell
    cp dev.env .env 
    ```

2. Set all empty env varaibles in .env file. 
3. In terminal set a directory to main repository directory.
4. Run a database instance in Docker container by running command bellow:

    ```shell
    docker compose -f docker-compose.database.yml up
    ```

5. If your local database is running, execute `local_migration.sh` script from `scripts` directory to run all migrations against database.
6. Now, your local database is ready to collect data from `data_extractors`.