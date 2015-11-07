# This builds artifacts needed by the production Rails image (eg, asset manifests).
# It cleans folders, generates the artifacts and then builds and pushes the production image.
#
# This will be run by Travis, when the master branch has been merged to.
# Any tests should have run and passed at this point.

# TODO(kr) need docker hub credentials
# ~/.docker/config.json

# Clear any previously built assets from dev or prod builds.
scripts/rails_clear.sh

# Build webpack container to perform the build, use it to build
# the assets for production, and then copy those artifacts into the 
# Rails project.
docker build -t webpack-building-production webpack/
docker run \
  -v ~/github/somerville-teacher-tool/webpack/src:/mnt/webpack/src \
  -v ~/github/somerville-teacher-tool/webpack/dist_production:/mnt/webpack/dist_production \
  webpack-building-production \
  npm run build:production
cp -r ~/github/somerville-teacher-tool/webpack/dist_production/* ~/github/somerville-teacher-tool/public/js

# Build the production Rails image and push it.
docker build -t kevinrobinson/somerville-teaching-tool:production_rails .
docker push kevinrobinson/somerville-teaching-tool:production_rails

# Clear any assets we generated in the process.
scripts/rails_clear.sh