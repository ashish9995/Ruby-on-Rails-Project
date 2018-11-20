json.extract! house, :id, :company_id, :location, :area, :year_built, :style, :list_prize, :floor_count, :basement, :owner_name, :created_at, :updated_at
json.url house_url(house, format: :json)
