# Submit a deploy to a production instance.
# usage: scripts/rails_submit_deploy.sh
INSTANCE_NAME=$1

source scripts/config.sh
source scripts/base_functions.sh


echo "Deploying $INSTANCE_NAME..."
echo "Looking up Postgres IP..."
POSTGRES_IP_ADDRESS=$(scripts/postgres_ip.sh)
echo "Found: $POSTGRES_IP_ADDRESS"

echo "Copying deploy script..."
scp -r scripts/ $INSTANCE_NAME.$DOMAIN_NAME:~
ssh $INSTANCE_NAME.$DOMAIN_NAME chmod u+x scripts/*.sh

echo "Submitting deploy command..."
ssh $INSTANCE_NAME.$DOMAIN_NAME scripts/rails_deploy_remote.sh $POSTGRES_IP_ADDRESS
