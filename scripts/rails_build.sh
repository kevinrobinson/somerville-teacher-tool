# This builds artifacts needed by the production Rails image (eg, asset manifests).
# It cleans folders, generates the artifacts and then builds and pushes the production image.
#
# Any tests should have run and passed at this point.
# Need docker hub credentials to have been set beforehand.

echo "Cleaning previously built assets from dev or prod builds..."
scripts/rails_clear.sh

echo "Building a webpack container to perform the build..."
docker build -t webpack-building-production webpack/

echo "Building production assets..."
docker run \
  -v ~/github/somerville-teacher-tool/webpack/src:/mnt/webpack/src \
  -v ~/github/somerville-teacher-tool/webpack/dist_production:/mnt/webpack/dist_production \
  webpack-building-production \
  npm run build:production

echo "Copying manifest to Rails and copying assets to S3..."
MANIFEST_FILE=webpack-assets.json
cp -r ~/github/somerville-teacher-tool/webpack/dist_production/$MANIFEST_FILE ~/github/somerville-teacher-tool/public/js/$MANIFEST_FILE
aws s3 cp ./webpack/dist_production s3://somerville-teaching-tool-cdn/production/js --exclude "$MANIFEST_FILE" --recursive

echo "Building the production Rails image..."
docker build -t kevinrobinson/somerville-teaching-tool:production_rails .

echo "Pushing the production Rails image to the Docker registry..."
docker push kevinrobinson/somerville-teaching-tool:production_rails

echo "Clearing any assets we generated in the process..."
scripts/rails_clear.sh

echo "Done."