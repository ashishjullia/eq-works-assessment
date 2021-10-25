#!/bin/bash
# Stop all containers
sudo docker container stop $(sudo docker container ls -aq)

# Remove all containers
sudo docker container rm $(sudo docker container ls -aq)

# Remove all volumes
yes | sudo docker system prune -a --volumes

# List running containers
sudo docker container ls -a

# Remove the "postgres-data" directory
sudo rm -rf postgres-data/

# Remove the "backup.sql" file
sudo rm -rf db-files/

# Remove the substituded .env files for a fresh stack
sudo rm ws-product-nodejs/.env ./.env