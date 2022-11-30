#!/bin/bash

#=============================================================================#
# Deploys Monitoring Containers
#=============================================================================#
#RED='\033[0;31m'
#YELLOW='\033[0;33m'
#GREEN='\033[0;32m'
#PURPLE='\033[0;35m'
#WHITE='\033[0m'

printf "${YELLOW}Deploying monitoring containers...${WHITE}\n"

# Deploy containers (TODO - run as docker stack)
docker ps --filter name=prometheus --filter name=promtail --filter name=loki -q | xargs --no-run-if-empty docker rm -f
docker ps --filter name=nodeexporter --filter name=cadvisor -q | xargs --no-run-if-empty docker rm -f
docker-compose up -d

# Finish
printf "${GREEN}Deployed monitoring containers${WHITE}\n"
printf "${PURPLE}$(docker-compose ps)${WHITE}\n"
#exit 0