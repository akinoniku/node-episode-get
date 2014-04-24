"use strict";
mongoose = require("mongoose")
Feed = mongoose.model("Feed")

### Get awesome things ###
exports.feeds = (req, res) ->
  Feed.find (err, feeds) ->
    unless err
      res.json feeds
    else
      res.send err
