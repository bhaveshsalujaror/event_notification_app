class Event < ApplicationRecord
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
end
