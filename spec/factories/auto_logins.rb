# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auto_login do
    sequence(:username) {|n| "User#{n}"}
  end
end
