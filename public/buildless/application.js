import raty from 'javascripts/raty'
import tmdb_search from 'javascripts/tmdb_search'
import movie_search from 'javascripts/movie_search'
import turbolinks from 'turbolinks'

turbolinks.start()

// Manually run notifyApplicationAfterPageLoad() which dispatches turbolinks:load
// to work around https://github.com/turbolinks/turbolinks/issues/281
turbolinks.controller.notifyApplicationAfterPageLoad()
