$(document).on "turbolinks:load", ->
  $field = $("#tmdb-title")
  $feedback = $field.parent().find(".form-control-feedback")
  $feedback.hide()

  $field.typeahead
    delay: 200
    displayText: (movie) ->
      title =
        if movie.title == movie.original_title
          movie.title
        else
          "#{movie.title} (#{movie.original_title})"
      year = movie.release_date.split("-")[0]
      "#{title} - #{year}"
    matcher: (movie) -> movie.release_date # ignore unreleased movies
    source: (query, process) ->
      $.ajax
        url: "/tmdb/search.json?query=#{query}"
        beforeSend: -> $feedback.fadeIn()
        complete: -> $feedback.fadeOut()
        success: process
    updater: (movie) ->
      $("#movie_tmdb_id").val(movie.id)
      $("#movie-submit").attr("disabled", false)
      movie
