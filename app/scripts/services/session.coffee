'use strict'

angular.module('nodeEpisodeGetApp')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
