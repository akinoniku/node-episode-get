"use strict";

mongoose = require("mongoose")
Schema = mongoose.Schema

kinds = ['AN','EP']

### Feed Schema ###
FeedSchema = new Schema(
  kind: String
  title: String
  url: String
  hash: String
  season: String
  episode: String
)


### Virtuals ###

### Validations ###
FeedSchema.path("kind").validate(((kind) ->
  kind in kinds
), "kind invalid")

FeedSchema.path("hash").validate ((value) ->
  self = @

  @constructor.findOne(
    {hash: value}
  , (err, hash) ->
      throw err  if err
      !!hash
  )), "The specified hash address is already added."

### Statics Methods ###
FeedSchema.statics =
  getSeason: (title)->
    season = title.match(/[Ss](\d+)/)?[1]
    if season? then season else ''
  getEpisode: (title)->
    episode = title.match(/\[(\d+)\]/)?[1]
    episode = title.match(/(\d+)[话話]/)?[1] unless episode
    episode = title.match(/[Ee](\d+)/)?[1] unless episode
    if episode? then episode else ''

module.exports = mongoose.model("Feed", FeedSchema)