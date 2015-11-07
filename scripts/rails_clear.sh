# This clears any dev or production assets in the Rails folder that may have
# been built by previous builds.

rm -rf tmp

# from webpack dev build
rm -rf ~/github/somerville-teacher-tool/webpack/dist_dev/*.*
rm -rf ~/github/somerville-teacher-tool/public/webpack_dev/*.* 

# from webpack production build
rm -rf ~/github/somerville-teacher-tool/webpack/dist_production/*.*
rm -rf ~/github/somerville-teacher-tool/public/js/*.* 
