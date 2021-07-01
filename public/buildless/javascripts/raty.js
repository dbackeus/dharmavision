const refreshAverageRating = movieId => $.ajax({
  url: `/movies/${movieId}.json`,
  success(movie) {
    $(".big-rating-star").html(movie.average_rating)
  }
})

document.addEventListener('turbolinks:load', () => {
  $("[data-raty]").raty({
    path: "",
    starOff: "/buildless/images/raty/star-off.png",
    starOn: "/buildless/images/raty/star-on.png",
    number: 10,
    hints: [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10"
    ],
    target() { return ".raty-target" },
    targetFormat: "<span class='raty-target-score'>{score}</span>/10",
    targetKeep: true,
    score() { return $(this).data("score") },
    click(score, e) {
      $(".raty-pending").fadeIn()
      $(".raty-success").hide()
      $(".raty-fail").hide()

      const movieId = $(this).data("movie-id")

      const params = {
        rating: {
          movie_id: movieId,
          rating: score
        }
      }

      return $.ajax({
        method: "POST",
        url: "/ratings.json",
        data: params,
        success() {
          $(".raty-pending").fadeOut(() => $(".raty-success").fadeIn())
          refreshAverageRating(movieId)
        },
        fail() {
          $(".raty-pending").fadeOut(() => $(".raty-fail").fadeIn())
        }
      })
    }
  })
})

export default "no export from raty"
