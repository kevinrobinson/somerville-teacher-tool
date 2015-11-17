function extract_field {
  node -e "console.log(JSON.parse(process.argv[1])['$2'])" $1
}

# Poll each second and block until INSTANCE_ID reaches TARGET_STATE.
# Will block indefinitely with no timeout.
function wait_for_instance_state {
  INSTANCE_ID=$1
  TARGET_STATE=$2
  while CURRENT_STATE=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].State.Name'); test "$CURRENT_STATE" != "$TARGET_STATE"; do
    sleep 1; echo -n '.'
  done; echo 'done.'
}

# Poll each second and block until VOLUME_ID reaches TARGET_STATE.
# Will block indefinitely with no timeout.
function wait_for_volume_state {
  VOLUME_ID=$1
  TARGET_STATE=$2
  while CURRENT_STATE=$(aws ec2 describe-volumes --volume-id $VOLUME_ID --output text --query 'Volumes[*].State'); test "$CURRENT_STATE" != "$TARGET_STATE"; do
    sleep 1; echo -n '.'
  done; echo 'done.'
}

# Queries for the public IP address of an instance.
function get_ip_for_instance {
  INSTANCE_ID=$1
  IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].PublicIpAddress')
  echo $IP_ADDRESS
}

# Queries for the public IP address of an instance by the instance name
function get_instance_id_from_name {
  INSTANCE_NAME=$1
  INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" --output text --query 'Reservations[*].Instances[*].InstanceId')
  echo $INSTANCE_ID
}