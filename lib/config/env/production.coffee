"use strict"
module.exports =
  env: "production"
  mongo:
    uri: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or "mongodb://localhost/fullstack"