# This builds artifacts needed by the production Rails image (eg, asset manifests).
# It cleans folders, generates the artifacts and then builds and pushes the production image.
#
# Any tests should have run and passed at this point.
# Need docker hub credentials to have been set beforehand.

# Clear any previously built assets from dev or prod builds.
scripts/rails_clear.sh

# Build webpack container to perform the build, use it to build
# the assets for production.
docker build -t webpack-building-production webpack/
docker run \
  -v ~/github/somerville-teacher-tool/webpack/src:/mnt/webpack/src \
  -v ~/github/somerville-teacher-tool/webpack/dist_production:/mnt/webpack/dist_production \
  webpack-building-production \
  npm run build:production

# Copy the manifest into the Rails folder, so the Rails HTML frame can point to the main JS file.
# And put the assets in S3, where the Cloudfront CDN will read them from.
MANIFEST_FILE=webpack-assets.json
cp -r ~/github/somerville-teacher-tool/webpack/dist_production/$MANIFEST_FILE ~/github/somerville-teacher-tool/public/js/$MANIFEST_FILE
aws s3 cp ./webpack/dist_production s3://somerville-teaching-tool-cdn/production/js --exclude "$MANIFEST_FILE" --recursive

# Build the production Rails image and push it.
docker build -t kevinrobinson/somerville-teaching-tool:production_rails .
docker push kevinrobinson/somerville-teaching-tool:production_rails

# Clear any assets we generated in the process.
scripts/rails_clear.sh