# Terminate an EC2 instance, and remove its DNS record as well.
# Any additional EBS volumes are detached but are not affected (the root
# EBS volume will be terminated by default).  This isn't very clever 
# and is intended only for the happy path of "destroying an instance created
# by a create script."
#
# It doesn't block to wait until the instance is actually terminated, just
# that it starts shutting down.
#
# example: scripts/base_destroy.sh rails2005
INSTANCE_NAME=$1

source scripts/config.sh
source scripts/base_functions.sh

echo "Destroying $INSTANCE_NAME..."

echo "Removing DNS record for $INSTANCE_NAME..."
scripts/base_delete_dns.sh $INSTANCE_NAME

echo "Terminating $INSTANCE_NAME..."
echo "Looking up instance-id for $INSTANCE_NAME..."
INSTANCE_ID=$(get_instance_id_from_name $INSTANCE_NAME)
echo "Instance id is: $INSTANCE_ID."
RESPONSE=$(aws ec2 terminate-instances --instance-ids $INSTANCE_ID)

# This will block indefinitely if it has already been terminated.
echo "Waiting for instance to be 'shutting-down'..."
wait_for_instance_state $INSTANCE_ID shutting-down

echo "Done destroying $INSTANCE_NAME."
