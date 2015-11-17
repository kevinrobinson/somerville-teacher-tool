# Get the IP of the primary Postgres server.
# No arguments

source scripts/config.sh
source scripts/base_functions.sh


# TODO(kr) hacking for now, with only one server.
INSTANCE_NAME=postgres2001

INSTANCE_ID=$(get_instance_id_from_name $INSTANCE_NAME)
IP_ADDRESS=$(get_ip_for_instance $INSTANCE_ID)
echo $IP_ADDRESS
