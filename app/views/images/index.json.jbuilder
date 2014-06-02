json.array!(@images) do |image|
  json.extract! image, :id, :filename, :location
  json.url image_url(image, format: :json)
end
