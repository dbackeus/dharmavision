const refreshAverageRating = (movieId) => {
  fetch(`/movies/${movieId}.json`, { method: "GET" })
    .then(response => response.json())
    .then(movie => document.getElementById("movie-rating-star").innerHTML = movie.average_rating)
}

document.addEventListener('turbolinks:load', () => {
  const rater = document.getElementById("rater")
  if(!rater) return

  const raterPending = document.getElementById("rater-pending")
  const raterScoreText = document.getElementById("rater-score-text")

  rater.addEventListener("sl-change", (e) => {
    const score = e.target.value
    const movieId = e.target.dataset.movieId

    raterScoreText.innerHTML = score

    raterPending.style.opacity = "100%"

    fetch("/ratings.json", {
      method: "POST",
      headers: {
        'X-CSRF_Token': Rails.csrfToken(),
        'Content-Type': "application/json",
      },
      body: JSON.stringify({
        rating: {
          movie_id: movieId,
          rating: score
        }
      }),
    }).then((e) => {
      raterPending.style.opacity = "0%"

      if(e.ok) {
        refreshAverageRating(movieId)
      }
      else {
        throw(new Error(`Unexpected server response code ${e.status}`))
      }
    }).catch((e) => {
      alert(`Something went wrong while sending your rating. Error message: ${e.message}`)
    })
  })
})

export default "no export from rater"
