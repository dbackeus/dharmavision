$ ->
  $field = $("#movie-search")

  $field.typeahead
    delay: 200
    displayText: (movie) ->
      """<div class="search-result"><img src="#{movie.thumbnail}">#{movie.title}</div>"""
    matcher: (movie) ->
      true
    source: (query, process) ->
      $.get("/movies/search.json?query=#{query}", process)
    updater: (movie) ->
      window.location = "/movies/#{movie.id}"
      null
    highlighter: (displayText) ->
      displayText
