# spec/factories/movies.rb
require 'faker'

FactoryGirl.define do
  factory :movie do
    title    "#{Faker::Name.name}"
    director "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  end
end
