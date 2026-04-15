class MealPlan < ApplicationRecord
  belongs_to :user
  has_many :recipes, dependent: :destroy
  has_one :chat, dependent: :destroy
end
