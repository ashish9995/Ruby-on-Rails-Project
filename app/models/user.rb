class User < ApplicationRecord
  validates :email_id, presence: true, uniqueness: true
  validates :password, presence: true

  def self.find_or_create_from_auth_hash(auth)
    exist_user = User.find_by(email_id: auth.info.email)
    # Create a new user if not registered by this email id
    if exist_user == nil
      user = User.new
      user.provider = auth.provider
      user.auth_uid = auth.uid
      user.email_id = auth.info.email
      user.is_realtor = true
      user.password = "."
      user.save!
      existing_real = Realtor.find_by(users_id: user.id)
      if existing_real == nil
        realtor = Realtor.new
        realtor.users_id = user.id
        realtor.first_name = auth.info.first_name
        realtor.last_name = auth.info.last_name
        realtor.save!
      end
      return user
    else
      if exist_user.auth_uid == nil
        exist_user.provider = auth.provider
        exist_user.auth_uid = auth.uid
        exist_user.save!
      end
      return exist_user
    end


  end
end
