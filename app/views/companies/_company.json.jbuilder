json.extract! company, :id, :name, :website, :address, :employee_count, :foundation_year, :revenue, :synopsis, :created_at, :updated_at
json.url company_url(company, format: :json)
