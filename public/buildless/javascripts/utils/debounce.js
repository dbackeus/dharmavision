// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// `wait` milliseconds.
const debounce = (method, wait) => {
  let timeout;

  return (...args) => {
    const later = () => {
      clearTimeout(timeout)
      method(...args)
    };

    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

export default debounce
