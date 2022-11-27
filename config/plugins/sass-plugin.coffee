# sass-plugin: compiles sass to css

sass = require 'sass'
path = require 'node:path'

name = 'sass-plugin'

compileSass = (code, options) -> sass.compile code, options


sassPlugin = (onLoadResult = {}) ->
  name: name
  setup: (build) =>
    build.onLoad { filter: /.\.(sass|scss)$/ }, (args) =>
      filename = path.relative do process.cwd, args.path
      try
        contents = compileSass(filename).css
        return {
          contents
          onLoadResult...
        }
      catch e
        console.log "error: #{name}:"
        console.error e
        process.exit 1


module.exports = sassPlugin
