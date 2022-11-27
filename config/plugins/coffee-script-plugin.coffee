# coffee-script-plugin: compiles coffeescript to javascript

path              = require 'node:path'
coffee            = require 'coffeescript'
{ readFileSync }  = require 'node:fs'

name = 'coffee-script-plugin'

compileCoffee = (code, options) -> coffee.compile code, options


coffeeScriptPlugin = (options = {}, onLoadResult = {}) ->
  name: name
  setup: (build) =>
    build.onLoad { filter: /.\.(coffee)$/ }, (args) =>
      source = readFileSync args.path, 'utf8'
      filename = path.relative do process.cwd, args.path

      try
        contents = compileCoffee source, { filename }
        return {
            contents
            onLoadResult...
        }
      catch e
        console.log "error: #{name}:"
        console.error e
        process.exit 1


module.exports = coffeeScriptPlugin
