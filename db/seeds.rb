# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create!(name: "Test APIer")
puts "Created 1 User: #{u.name}"

u.access_keys.create!
u.access_keys.last.update!(token: "0241779ada9b54f47w27")

puts "Created 1 access key for User: #{u.name}"
