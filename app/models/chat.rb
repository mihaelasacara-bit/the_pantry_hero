class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :meal_plan, dependent: :destroy
  has_many :messages, dependent: :destroy
end
