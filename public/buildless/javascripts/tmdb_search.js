import debounce from "javascripts/utils/debounce"

let feedback
let tmdbIdInput
let submitButton
let resultList

async function onSearchInput(e) {
  feedback.style.opacity = '100%'

  const query = e.target.value
  const html = await fetch(`/tmdb/search?query=${query}`, {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(response => response.text())

  feedback.style.opacity = '0%'

  resultList.style.display = html ? "block" : "none"
  resultList.innerHTML = html
}

document.addEventListener("turbolinks:load", () => {
  const input = document.getElementById("tmdb-title")
  if(!input) return

  input.addEventListener("input", debounce(onSearchInput, 200))

  feedback = document.getElementById("tmdb-spinner")
  feedback.style.opacity = '0%'

  tmdbIdInput = document.getElementById("movie_tmdb_id")
  submitButton = document.getElementById("movie-submit")
  resultList = document.getElementById("tmdb-search-results")
})

export default "no export from tmdb search"
