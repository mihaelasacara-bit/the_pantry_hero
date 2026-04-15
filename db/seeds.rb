
puts "Cleaning database..."

Message.delete_all
Chat.delete_all
Recipe.delete_all
MealPlan.delete_all
User.delete_all

puts "Seeding data..."

# 1. Create Users
user1 = User.create!(
  email: "alex@example.com",
  password: "password123",
)

user2 = User.create!(
  email: "sam@example.com",
  password: "password123",
)

# 2. Create Meal Plans
plan1 = MealPlan.create!(
  user: user1,
  start_date: Date.today
)

plan2 = MealPlan.create!(
  user: user2,
  start_date: Date.today
)

# 3. Create Recipes
# These link directly to the meal_plans via meal_plan_id
Recipe.create!(
  meal_plan: plan1,
  type: "Dinner",
  recipe_day: 1,
  ingredients: "Tofu, Broccoli, Soy Sauce, Sesame Oil",
  instructions: "Press tofu. Stir fry with broccoli and sauce. Serve hot."
)

Recipe.create!(
  meal_plan: plan1,
  type: "Dinner",
  recipe_day: 2,
  ingredients: "Pasta, Tomato Sauce, Basil",
  instructions: "Boil pasta. Heat sauce. Mix and serve."
)

Recipe.create!(
  meal_plan: plan1,
  type: "Dinner",
  recipe_day: 3,
  ingredients: "Rice, Chickpeas, Curry Paste",
  instructions: "Cook rice. Simmer chickpeas with curry paste. Serve together."
)

Recipe.create!(
  meal_plan: plan1,
  type: "Dinner",
  recipe_day: 4,
  ingredients: "Wraps, Hummus, Peppers",
  instructions: "Spread hummus on wraps, add peppers, roll up and serve."
)

Recipe.create!(
  meal_plan: plan2,
  type: "Dinner",
  recipe_day: 2,
  ingredients: "Avocado, Bacon, Eggs, Spinach",
  instructions: "Fry bacon and eggs. Serve over fresh spinach with sliced avocado."
)
