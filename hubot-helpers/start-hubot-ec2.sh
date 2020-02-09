#!/bin/bash

set -exo pipefail

INSTANCEID="i-09b13ea604c792395"
COUNTER=0
INSTANCESTATE=$(aws2 ec2 describe-instances --instance-id "${INSTANCEID}" --query 'Reservations[*].Instances[*].State.Name' --output text)
INSTANCENAME=$(aws2 ec2 describe-instances --instance-id "${INSTANCEID}" --query 'Reservations[*].Instances[*].KeyName' --output text)

if [ ${INSTANCESTATE} = "stopped" ]; then
    aws2 ec2 start-instances --instance-ids ${INSTANCEID}
fi

while [ ${INSTANCESTATE} != "running" ]; do
    INSTANCESTATE=$(aws2 ec2 describe-instances --instance-id "${INSTANCEID}" --query 'Reservations[*].Instances[*].State.Name' --output text)
    COUNTER=$((COUNTER + 1))
    if [ ${COUNTER} -eq 12 ]; then
        echo "Looks like your instance is taking a while to come online. \
        You should check to see if there is a problem"
        exit 1
    fi
    echo "waiting for instance to come online..."
    sleep 5
done

echo "Instance ${INSTANCENAME} is online!"
