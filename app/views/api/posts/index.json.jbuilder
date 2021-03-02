json.array! @posts.each do |post|
  json.id post.id
  json.title post.title
  json.body post.body
  json.image post.image
  json.is_owner current_user && current_user.id == post.user_id
end
