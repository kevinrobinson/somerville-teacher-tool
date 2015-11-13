# Create a Rails instance, tags it with the name, create a DNS entry for it and outputs the instance id.
# example: rails_create.sh INSTANCE_NAME
INSTANCE_NAME=$1

source scripts/config.sh
source scripts/base_functions.sh


echo "Creating Rails instance $INSTANCE_NAME..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_IMAGE_ID \
  --instance-type t2.micro \
  --key-name $KEY_NAME \
  --security-group-ids $SG_DEFAULT $SG_SSH_ACCESS $SG_WEB_TRAFFIC \
  --output text \
  --query 'Instances[*].InstanceId')
echo "Created $INSTANCE_ID..."

echo "Waiting for instance to be 'pending'..."
wait_for_instance_state $INSTANCE_ID pending

echo "Creating $INSTANCE_NAME name tag..."
TAG_RESPONSE=$(aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$INSTANCE_NAME)

echo "Waiting for instance to be 'running'..."
wait_for_instance_state $INSTANCE_ID running

echo "Adding DNS entry for $INSTANCE_NAME.$DOMAIN_NAME..."
scripts/base_create_dns.sh $INSTANCE_ID $INSTANCE_NAME.$DOMAIN_NAME

echo "Done creating Rails instance."
echo $INSTANCE_ID