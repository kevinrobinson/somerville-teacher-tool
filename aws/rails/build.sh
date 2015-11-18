# This builds artifacts needed by the production Rails image (eg, asset manifests).
# It cleans folders, generates the artifacts and then builds and pushes the production image.
#
# Any tests should have run and passed at this point.
# Need docker hub credentials to have been set beforehand.

echo "Cleaning previously built assets from dev or prod builds..."
sudo ls -alt volumes/webpack_build/*
sudo rm -rf volumes/webpack_build/* # because Docker commands run as sudo in Travis

echo "Building production assets..."
docker-compose run webpack npm run build:production

echo "Copying manifest to Rails and copying assets to S3..."
MANIFEST_FILE=webpack-assets.json
aws s3 cp volumes/webpack_build/production s3://somerville-teaching-tool-cdn/production/js --exclude "$MANIFEST_FILE" --recursive

echo "Building the production Rails image..."
docker-compose build -t kevinrobinson/somerville-teaching-tool:production_rails rails

echo "Pushing the production Rails image to the Docker registry..."
docker push kevinrobinson/somerville-teaching-tool:production_rails

echo "Clearing any assets we generated in the process..."
sudo ls -alt volumes/webpack_build/*
sudo rm -rf volumes/webpack_build/* # because Docker commands run as sudo in Travis

echo "Done."