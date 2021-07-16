function clamp(value, min, max) {
  if (value < min) return min
  if (value > max) return max
  return value
}

const numberOfStars = 10

class Rater extends HTMLElement {
  connectedCallback() {
    this.value = this.getAttribute("value")
    const oneToNumberOfStars = Array.from({ length: numberOfStars }, (x, i) => i + 1)

    this.innerHTML = `
      <div class="inline-flex space-x-1 text-gray-300">
        ${oneToNumberOfStars.map(i =>
          `
            <button data-value="${i}" class="w-5 h-5 transform focus:outline-none">
              <svg class="w-full h-full" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"></path>
              </svg>
            </button>
          `
        ).join('')}
      </div>
    `

    this.addEventListener("mouseenter", e => {
     this.isHovering = true
    })

    this.addEventListener("mouseleave", e => {
      this.isHovering = false
      this.refresh()
    })

    this.addEventListener("mousemove", e => {
      this.hoverValue = this.getValueFromMousePosition(event)
      this.refresh()
    })

    this.addEventListener("click", e => {
      const newValue = this.getValueFromMousePosition(event)
      this.value = newValue == this.value ? 0 : newValue // reset to 0 if user clicks the current value
      this.dispatchEvent(new CustomEvent('change', { value: this.value }))
      this.refresh()
    })

    this.ratingButtons = [...this.querySelectorAll("[data-value]")]

    this.refresh()
  }

  getValueFromMousePosition(e) {
    return this.getValueFromXCoordinate(e.clientX)
  }

  getValueFromXCoordinate(coordinate) {
    const containerLeft = this.getBoundingClientRect().left
    const containerWidth = this.getBoundingClientRect().width
    const value = Math.ceil(((coordinate - containerLeft) / containerWidth) * numberOfStars)
    return clamp(value, 0, numberOfStars)
  }

  refresh() {
    const valueToRender = parseInt(this.isHovering ? this.hoverValue : this.value)

    this.ratingButtons.forEach(button => {
      const buttonValue = parseInt(button.dataset.value)
      button.classList.remove('text-yellow-400', 'scale-125')
      if (valueToRender >= buttonValue) button.classList.add('text-yellow-400')
      if (this.isHovering && valueToRender == buttonValue) button.classList.add('scale-125')
    })
  }
}

customElements.define("dv-rater", Rater)
