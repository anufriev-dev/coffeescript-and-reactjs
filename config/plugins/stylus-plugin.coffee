# stylus-plugin: compiles stylus to css

stylus            = require 'stylus'
{ readFileSync }  = require 'node:fs'
{ errorLog }      = require '../helpers'

name              = 'stylus-plugin'

compileStylus= (code) -> stylus.render code


stylusPlugin = (onLoadResult = {}) ->
  name: name
  setup: (build) =>
    build.onLoad filter: /.\.(stylus|styl)$/, (args) =>
      source = readFileSync args.path, 'utf8'
      try
        contents = compileStylus source
        return {
          contents
          onLoadResult...
        }
      catch e
        errorLog(name,e)


module.exports = stylusPlugin
