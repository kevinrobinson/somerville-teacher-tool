var path = require('path');

module.exports = {
  entry: {
    app: ['./src/index.js']
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    publicPath: '/javascripts',
    filename: 'webpack_bundle.js',
    library: 'SomervilleTeacherToolUi',
    libraryTarget: 'umd'
  },
  resolve: {
    extensions: ['', '.js']
  },
  watchOptions: {
    poll: true
  }
};