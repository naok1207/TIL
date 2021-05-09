const path = require('path');

module.exports = {
  entry: [
    'babel-polyfill',
    'react-hot-loader/path',
    './src/index.js'
  ],
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /|.js$/,
        use: {
          loader: 'babel-loader',
          options: {
            preset: [
              ['env', { modules: false }],
              'react'
            ],
            plugins: ['react-hot-loader/babel']
          }
        }
      }
    ]
  },
  devServer: {
    contentBase: path.join(__dirname, 'public'),
    port: 9000
  }
}