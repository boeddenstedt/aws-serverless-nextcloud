#!/bin/bash

if [[ ! -f $1 ]];then
   echo "> generating environment file from template"
   cp environment.tmpl $1
   echo ">>> Please fill out '$1' and run the script again to deploy"
   exit 0
fi
source $1

set -x
aws cloudformation deploy \
    --template-file ${OUTPUT_TEMPLATE_FILE} \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
        SuspendAutoScaling=true
set +x
sleep 10
set -x
aws cloudformation deploy \
    --template-file ${OUTPUT_TEMPLATE_FILE} \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
        NextCloudVersion=${NC_VERSION}

