class House < ApplicationRecord
  validates :realtor_id, presence: true
  belongs_to :realtor
  has_many_attached :images
end
