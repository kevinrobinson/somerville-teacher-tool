# This will be run by Travis.
# Any tests should have run and passed at this point.

# Only run when the master branch has been merged to, not on pull requests.
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
elif [ "${TRAVIS_BRANCH}" != "master"]; then
  exit 0
fi

# Set Docker Hub credentials
docker login --email=$DOCKER_EMAIL --password=$DOCKER_PASSWORD --username=$DOCKER_USERNAME

# Build and push the Rails image
aws/rails/build.sh
