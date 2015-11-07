# Webpack
This builds the JS, CSS and image assets for the UI.

It currently builds two kinds of artifacts: a single JS bundle and JPG image assets.  CSS and smaller PNG files are inlined.


# Organization
`src` - source code for JS, CSS and images
`dist_dev` - folder for `npm run watch` and `npm run build:dev` to build into
`dist_production` - folder for `npm run build:production` to build into


# Development mode
In development mode, `docker-compose up` will start up all services for development, including a container running Webpack in `watch` mode that will watch the filesysem, run webpack bash` from the root folder.

#### Volume mounting
package.json
Webpack configuration changes
Files in `src`


# Building for production
To build the project for production, you should run `scripts/rails_build.sh` from the root folder.  It will ultimately run `npm run build:production` in this container to produce production artifacts.  