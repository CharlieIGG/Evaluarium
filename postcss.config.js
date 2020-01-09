const moveProps = require('postcss-move-props-to-bg-image-query');

module.exports = {
  plugins: [
    moveProps(),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
