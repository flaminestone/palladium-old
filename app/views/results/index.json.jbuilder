json.array!(@results) do |result|
  json.extract! result, :id, :status, :message, :author
  json.url result_url(result, format: :json)
end
