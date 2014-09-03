json.array!(@images) do |image|
  json.extract! image, :id, :location, :photo, :tag_1, :tag_2, :tag_3
  json.url image_url(image, format: :json)
end
