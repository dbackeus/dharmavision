json.array! @results do |movie|
  json.id movie.id.to_s
  json.title movie.title
  json.original_title movie.original_title
  json.year movie.year
  json.thumbnail movie.poster_url(92)
end
