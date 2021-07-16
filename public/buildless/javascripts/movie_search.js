import debounce from "javascripts/utils/debounce"

let resultList
let selectedIndex
let input

document.addEventListener("turbolinks:load", () => {
  resultList = document.getElementById("movie-search-results")

  input = document.getElementById("movie-search")
  input.addEventListener("input", debounce(onSearchInput, 200))
  input.addEventListener("keydown", onKeyDown)
})

async function onSearchInput(e) {
  selectedIndex = -1

  const query = e.target.value
  const html = await fetch(`/movies/search?query=${query}`, {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(response => response.text())

  resultList.style.display = html ? "block" : "none"
  resultList.innerHTML = html
}

function onKeyDown(e) {
  switch (e.key) {
    case "ArrowDown":
      e.preventDefault()
      selectedIndex++
      select()
      break
    case "ArrowUp":
      e.preventDefault()
      selectedIndex--
      select()
      break
    case "Enter":
      const selectedListItem = resultList.querySelectorAll("li")[selectedIndex]
      if(selectedListItem) {
        e.preventDefault()
        selectedListItem.querySelector("a").click()
      }
      break
    case "Escape":
      input.value = null
      resultList.innerHTML = null
  }
}

function select() {
  const resultListItems = resultList.querySelectorAll("li")
  if(resultListItems.length == 0) return

  [...resultListItems].forEach(li => li.classList.remove("bg-blue-100"))

  if(selectedIndex < 0) selectedIndex = resultListItems.length - 1
  if(selectedIndex > resultListItems.length - 1) selectedIndex = 0

  resultListItems[selectedIndex].classList.add("bg-blue-100")
}

export default "no export from movie search"
