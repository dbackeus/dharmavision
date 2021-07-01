document.addEventListener("turbolinks:load", () => {
  const $field = $("#tmdb-title")
  const $feedback = $field.parent().find(".form-control-feedback")
  $feedback.hide()

  return $field.typeahead({
    delay: 200,
    displayText(movie) {
      const title =
        movie.title === movie.original_title ?
          movie.title
        :
          `${movie.title} (${movie.original_title})`
      const year = movie.release_date.split("-")[0]
      return `${title} - ${year}`
    },
    matcher(movie) { return movie.release_date }, // ignore unreleased movies
    source(query, process) {
      return $.ajax({
        url: `/tmdb/search.json?query=${query}`,
        beforeSend() { return $feedback.fadeIn() },
        complete() { return $feedback.fadeOut() },
        success: process
      })
    },
    updater(movie) {
      $("#movie_tmdb_id").val(movie.id)
      $("#movie-submit").attr("disabled", false)
      return movie
    }
  })
})

export default "no export from tmdb search"
