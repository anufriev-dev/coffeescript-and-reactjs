# stylus-plugin: compiles stylus to css

path              = require 'node:path'
stylus            = require 'stylus'
{ readFileSync }  = require 'node:fs'

name = 'stylus-plugin'

compileStylus= (code) -> stylus.render code


stylusPlugin = (onLoadResult = {}) ->
  name: name
  setup: (build) =>
    build.onLoad { filter: /.\.(stylus|styl)$/ }, (args) =>
      source = readFileSync args.path, 'utf8'
      try
        contents = compileStylus(source)
        return {
          contents
          onLoadResult...
        }
      catch e
        console.log "error: #{name}:"
        console.error e
        process.exit 1


module.exports = stylusPlugin
