class MealPlan < ApplicationRecord
<<<<<<< Updated upstream
  belongs_to :user

  has_many :recipes, dependent: :destroy
  has_one :chat, dependent: :destroy
=======
  belongs_to :user, foreign_key: "id_users"
  has_many :recipes, foreign_key: "id_meal_plans", dependent: :destroy
  has_one :chat, foreign_key: "id_meal_plans", dependent: :destroy
>>>>>>> Stashed changes
end
