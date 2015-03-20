$ ->
  $field = $("#imdb-title")
  $feedback = $("#imdb-title").parent().find(".form-control-feedback")
  $feedback.hide()

  $field.typeahead
    delay: 200
    displayText: (movie) -> movie.title
    matcher: (movie) -> true
    source: (query, process) ->
      request = $.get("/imdb/search.json?query=#{query}", beforeSend: -> $feedback.fadeIn())
      request.then -> $feedback.fadeOut()
      request.success(process)
      request
    updater: (movie) ->
      $("#movie_imdb_id").val(movie.id)
      $("#movie-submit").attr("disabled", false)
      movie.title
