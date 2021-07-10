#!/bin/bash

if [[ ! -f $1 ]];then
   echo "> generating environment file from template"
   cp environment.tmpl $1
   echo ">>> Please run the script again to deploy"
   exit 0
fi
source $1

aws cloudformation package \
            --template-file ecs-nextcloud.yml \
            --s3-bucket ${CFN_NC_ARTEFACT} \
            --output-template-file ${OUTPUT_TEMPLATE_FILE}
aws cloudformation deploy \
    --template-file ${OUTPUT_TEMPLATE_FILE} \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
        DbUserName=${DB_USER_NAME} \
        DbPassword=${DB_PASS} \
        NextCloudDbName=${DB_NAME} \
        NextCloudAdminUser=${NC_ADMIN_USER} \
        NextCloudAdminPassword=${NC_ADMIN_PASS} \
        Route53Zone=${R53_ZONE} \
        Domain=${R53_DOMAIN} \
        IsolationLevel=${ISOLATION_LEVEL} \
        SuspendAutoScaling=false \
        EcsCapacityProvider=${ESC_CAP_PROVIDER} \
        EcsMinCapacity=${ESC_CAP_MIN} \
        EcsMaxCapacity=${ESC_CAP_MAX} \
        EcsTaskCpu=${ECS_TASK_CPU} \
        EcsTaskMem=${ECS_TASK_MEM} \
        NextCloudVersion=${NC_VERSION} \
    --capabilities CAPABILITY_IAM \
    --tags env=${TAG_ENV} service=${TAG_SERVICE}
