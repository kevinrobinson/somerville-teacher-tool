var webpack = require('webpack');
var path = require('path');
var _ = require('lodash');
var AssetsPlugin = require('assets-webpack-plugin');

var sharedConfig = require('./webpack.config.shared.js');
var outputPath = path.resolve(__dirname, 'dist_production');
module.exports = _.merge(sharedConfig, {
  output: {
    path: outputPath,
    publicPath: '/javascripts',
    filename: '[name]-[chunkhash].js'
  },
  plugins: [
    new AssetsPlugin({ path: outputPath }),
    new webpack.optimize.UglifyJsPlugin()
    // new webpack.optimize.OccurenceOrderPlugin()
  ]
});