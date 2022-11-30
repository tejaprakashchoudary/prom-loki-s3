#!/bin/bash

#=============================================================================#
# Create .env for monitoring based on current server
#=============================================================================#

#RED='\033[0;31m'
#YELLOW='\033[0;33m'
#GREEN='\033[0;32m'
#WHITE='\033[0m'
printf "${YELLOW}Creating monitoring .env...\n${WHITE}"

# Sanity Checks on Inputs
if [ "$#" -ne 1 ]; then
  echo "Incorrect number of arguments to create .env file" >&2
  exit 1
fi
# Setup Variables
ENVIRONMENT=$1

# Check Environments
if [ "$ENVIRONMENT" == 'local' ];then
        :
elif [ "$ENVIRONMENT" == 'ci' ];then
        :
elif [ "$ENVIRONMENT" == 'sandbox' ];then
        :
elif [ "$ENVIRONMENT" == 'dev' ];then
        :
elif [ "$ENVIRONMENT" == 'qa' ];then
        :
elif [ "$ENVIRONMENT" == 'prod' ];then
        :
else
      echo "Unknown Environment"
      exit 1
fi


#=============================================================================#
# Server Specific Variables
#=============================================================================#
SERVER=$(hostname)
PUBLIC_IP="$(curl ifconfig.io)"
PRIVATE_IP="$(hostname -I | cut -d' ' -f1)"
NODEEXPORTER_TARGET="${PRIVATE_IP}:9100"
CADVISOR_TARGET="${PRIVATE_IP}:8100"
KAFKA_TARGET="${PRIVATE_IP}:9997"

#=============================================================================#
# Create .env
#=============================================================================#
file=/tmp/env_file
cat  config/common.env > $file 
echo "" >> $file
echo "#=============================================================================#" >> $file
echo "# Node Variables" >> $file
echo "#=============================================================================#" >> $file
echo "ENVIRON=${ENVIRONMENT}" >> $file
echo "SERVER=${SERVER}" >> $file
echo "PUBLIC_IP=${PUBLIC_IP}" >> $file
echo "PRIVATE_IP=${PRIVATE_IP}" >> $file
echo "NODEEXPORTER_NAME=${SERVER}-node" >> $file
echo "KAFKA_NAME=${SERVER}-kafka" >> $file
echo "CADVISOR_NAME=${SERVER}-cadvisor" >> $file
echo "PROMTAIL_NAME=${SERVER}-containers" >> $file
echo "PROMTAIL_LABEL=${SERVER}-container-logs" >> $file
echo "NODEEXPORTER_TARGET=${NODEEXPORTER_TARGET}" >> $file
echo "CADVISOR_TARGET=${CADVISOR_TARGET}" >> $file
echo "KAFKA_TARGET=${KAFKA_TARGET}" >> $file
# Swap over final file
cp $file .env
cat .env

#=============================================================================#
# Replace variables in monitoring config (might need to use jq here)
#=============================================================================#
set -a
source .env
envsubst < config/prometheus.yml | tee prometheus.yml
envsubst < config/promtail.yml | tee promtail.yml
envsubst < config/loki.yml | tee loki.yml
set +a

printf "\n${GREEN}Created monitoring .env\n${WHITE}"
#exit 0