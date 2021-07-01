$(document).on("turbolinks:load", function() {
  $("#movie-search").typeahead({
    delay: 200,
    displayText(movie) {
      if (!movie) { return }

      const title =
        movie.title === movie.original_title ?
          movie.title
        :
          `${movie.title} (${movie.original_title})`

      return `<div class="search-result"><img src="${movie.thumbnail}">${title} - ${movie.year}</div>`
    },
    matcher(movie) { return true },
    source(query, process) {
      return $.get(`/movies/search.json?query=${query}`, data => {
        process(data)
        this.$menu.addClass("hidden-xs")
      })
    },
    updater(movie) {
      Turbolinks.visit(`/movies/${movie.id}`)
    }, // avoid displayText ending up in the search field when navigating
    highlighter(displayText) {
      return displayText
    }
  })
})

export default "no export from movie search"
