$(document).on "turbolinks:load", ->
  $("#movie-search").typeahead
    delay: 200
    displayText: (movie) ->
      title =
        if movie.title == movie.original_title
          movie.title
        else
          "#{movie.title} (#{movie.original_title})"

      """<div class="search-result"><img src="#{movie.thumbnail}">#{title} - #{movie.year}</div>"""
    matcher: (movie) ->
      true
    source: (query, process) ->
      $.get "/movies/search.json?query=#{query}", (data) =>
        process(data)
        @$menu.addClass("hidden-xs")
    updater: (movie) ->
      window.location = "/movies/#{movie.id}"
      null
    highlighter: (displayText) ->
      displayText
