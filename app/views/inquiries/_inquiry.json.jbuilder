json.extract! inquiry, :id, :subject, :content, :user_id, :house_id, :created_at, :updated_at
json.url inquiry_url(inquiry, format: :json)
