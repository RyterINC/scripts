#!/bin/bash

set -exo pipefail

INSTANCE_ID="i-09b13ea604c792395"
INSTANCE_STATE=$(aws2 ec2 describe-instances --instance-id "${INSTANCE_ID}" --query 'Reservations[*].Instances[*].State.Name' --output text)
INSTANCE_DNS=$(aws2 ec2 describe-instances --instance-id "${INSTANCE_ID}" --query 'Reservations[*].Instances[*].PublicDnsName' --output text)

if [ ${INSTANCE_STATE} = "running" ]; then
    ssh -i ~/.ssh/hubot_key ec2-user@"${INSTANCE_DNS}"
else
    echo "Your instance isn't running."    
fi
