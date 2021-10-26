#!/bin/bash
# DATA_DIRECTORY="$1"
# DB_FILES_DIRECTORY="$2"

# envsubst < ./services.env
source ./services.env

# init
if [ ! -d "$DATA_DIRECTORY" ] && [ ! -d "$DB_FILES_DIRECTORY" ]
then
    mkdir $DATA_DIRECTORY $DB_FILES_DIRECTORY
    envsubst < "./env-templates/app.env.template" > "./ws-product-nodejs/.env"
    envsubst < "./env-templates/stack.env.template" > "./.env"
    echo "Proceeding with the stack."
    sudo docker run -i --rm -e PGPASSWORD=${PGPASSWORD} postgres /usr/bin/pg_dump -O -x -h ${PGHOST} -U readonly work_samples > ./${DB_FILES_DIRECTORY}/backup.sql 
    sudo docker-compose up -d prepare-data
    sudo docker-compose up -d app
else
	echo "Directories $DATA_DIRECTORY AND $DB_FILES_DIRECTORY already present."
    if [ "$(ls -A $DATA_DIRECTORY)" ] && [ "$(ls -A $DB_FILES_DIRECTORY)" ]; then
     echo "$DATA_DIRECTORY AND $DB_FILES_DIRECTORY are not Empty."
	else
    echo "$DATA_DIRECTORY AND AND $DB_FILES_DIRECTORY are Empty."
    # capture data
    envsubst < "./env-templates/app.env.template" > "./ws-product-nodejs/.env"
    envsubst < "./env-templates/stack.env.template" > "./.env"
    echo "Proceeding with the stack."
    sudo docker run -i --rm -e PGPASSWORD=${PGPASSWORD} postgres /usr/bin/pg_dump -O -x -h ${PGHOST} -U readonly work_samples > ./${DB_FILES_DIRECTORY}/backup.sql 
    sudo docker-compose up -d prepare-data
    sudo docker-compose up -d app
	fi
fi
