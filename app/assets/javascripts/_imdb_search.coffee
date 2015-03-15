$ ->
  $field = $("#imdb-title")

  $field.typeahead
    delay: 200
    displayText: (movie) -> movie.title
    matcher: (movie) -> true
    source: (query, process) ->
      $.get("/imdb/search.json", query: query).success(process)
    updater: (movie) ->
      $("#movie_imdb_id").val(movie.id)
      $("#movie-submit").attr("disabled", false)
      movie.title
