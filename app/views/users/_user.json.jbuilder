json.extract! user, :id, :email_id, :password, :is_admin, :is_realtor, :is_househunter, :created_at, :updated_at
json.url user_url(user, format: :json)
