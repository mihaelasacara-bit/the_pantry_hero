class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :meal_plan
  has_many :messages
end
