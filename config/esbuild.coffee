# entry point

require('dotenv').config path: './config/.env'

{ dev, build } = require "."


switch process.argv[2]
  when 'dev'
    do dev
  when 'build'
    do build
