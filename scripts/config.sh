# This script defines environment variables about the AWS configuration that are
# used by other scripts.

# Credentials for authenticating with the AWS API
export KEY_NAME=

# For performing ssh operations on new boxes
export SUPERUSER=
export SUPERUSER_PEM_FILE=

# DNS and domain name configuration
export DOMAIN_NAME=
export HOSTED_ZONE_ID=

# Security group names.  Create these manually and update here.
export SG_DEFAULT=
export SG_POSTGRES=
export SG_SSH_ACCESS=
export SG_WEB_TRAFFIC=

# AMI image for all nodes
export AMI_IMAGE_ID=