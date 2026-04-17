class Recipe < ApplicationRecord
  belongs_to :meal_plan
<<<<<<< Updated upstream
  # This line tells Rails NOT to use 'type' for STI
  self.inheritance_column = :_type_disabled
=======
>>>>>>> Stashed changes
end
