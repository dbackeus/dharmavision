$ ->
  $("[data-raty]").raty
    path: "/assets/raty/lib/images"
    number: 10
    hints: [
      "Click to rate 1"
      "Click to rate 2"
      "Click to rate 3"
      "Click to rate 4"
      "Click to rate 5"
      "Click to rate 6"
      "Click to rate 7"
      "Click to rate 8"
      "Click to rate 9"
      "Click to rate 10"
    ],
    score: -> $(@).data("score")
    click: (score, e) ->
      params =
        rating:
          movie_id: $(@).data("movie-id")
          rating: score

      $.post "/ratings.json", params
