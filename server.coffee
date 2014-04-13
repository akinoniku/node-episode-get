"use strict"
express = require("express")
path = require("path")
fs = require("fs")
mongoose = require("mongoose")

###
Main application file
###

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or "development"

# Application Config
config = require("./lib/config/config")

# Connect to database
db = mongoose.connect(config.mongo.uri, config.mongo.options)

# Bootstrap models
modelsPath = path.join(__dirname, "lib/models")
fs.readdirSync(modelsPath).forEach (file) ->
  require modelsPath + "/" + file  if /(.*)\.(js$|coffee$)/.test(file)
  return


# Populate empty DB with sample data
require "./lib/config/dummydata"

# Passport Configuration
passport = require("./lib/config/passport")
app = express()

# Express settings
require("./lib/config/express") app

# Routing
require("./lib/routes") app

# Start server
app.listen config.port, ->
  console.log "Express server listening on port %d in %s mode", config.port, app.get("env")
  return


# Expose app
exports = module.exports = app