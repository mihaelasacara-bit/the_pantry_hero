class MealPlan < ApplicationRecord
  # Connects to the 'id_users' column in your database
  belongs_to :user, foreign_key: "id_users"
  # Connects to the recipes and ensures they are deleted if the plan is
  has_many :recipes, foreign_key: "id_meal_plans", dependent: :destroy
  # Connects to your one-and-only chatbot session
  has_one :chat, foreign_key: "id_meal_plans", dependent: :destroy
end
