json.array! @results do |movie|
  json.id movie.id.to_s
  json.title movie.title
  json.thumbnail movie.poster_url("w92")
end
