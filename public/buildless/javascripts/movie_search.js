import debounce from "javascripts/utils/debounce"

let resultList

async function onSearchInput(e) {
  const query = e.target.value
  const html = await fetch(`/movies/search?query=${query}`, {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(response => response.text())

  resultList.style.display = html ? "block" : "none"
  resultList.innerHTML = html
}

document.addEventListener("turbolinks:load", () => {
  resultList = document.getElementById("movie-search-results")

  const input = document.getElementById("movie-search")
  input.addEventListener("input", debounce(onSearchInput, 200))
})

export default "no export from movie search"
