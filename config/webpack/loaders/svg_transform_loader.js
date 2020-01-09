module.exports = {
  test: /\.svg(\?.*)?$/, // match img.svg and img.svg?param=value
  use: [
    'url-loader', // or file-loader or svg-url-loader
    'svg-transform-loader'
  ]
}