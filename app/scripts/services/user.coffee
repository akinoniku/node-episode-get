"use strict"

angular.module("nodeEpisodeGetApp")
  .factory "User", ($resource) ->
    $resource "/api/users/:id",
      id: "@id"
    ,
      update:
        method: "PUT"
        params: {}

      get:
        method: "GET"
        params:
          id: "me"
