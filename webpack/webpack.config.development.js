var path = require('path');
var _ = require('lodash');
var sharedConfig = require('./webpack.config.shared.js');


module.exports = _.merge(sharedConfig, {
  output: {
    path: path.resolve(__dirname, 'dist_dev'),
    publicPath: '/javascripts',
    filename: 'webpack_bundle.js'
  },
  devtool: "source-map", // or "inline-source-map"
  watchOptions: {
    poll: true
  }
});