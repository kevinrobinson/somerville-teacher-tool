# Submit a deploy to a production instance.
# usage: scripts/rails_submit_deploy.sh POSTGRES_IP_ADDRESS
INSTANCE_NAME=$1
POSTGRES_IP_ADDRESS=$2

source scripts/config.sh
source scripts/base_functions.sh


echo "Copying deploy script..."
scp -r scripts/ $INSTANCE_NAME.$DOMAIN_NAME:~
ssh $INSTANCE_NAME.$DOMAIN_NAME chmod u+x scripts/*.sh

echo "Submitting deploy command..."
ssh $INSTANCE_NAME.$DOMAIN_NAME scripts/rails_deploy.sh $POSTGRES_IP_ADDRESS
