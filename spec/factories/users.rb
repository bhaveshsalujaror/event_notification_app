FactoryBot.define do
  factory :user do
    email { Faker::IDNumber.south_african_id_number+'@abc.com' }
    password { "Abhbhbhedwjwksjwndhbjdnwjn" }
  end
end 