FactoryGirl.define do
  
  factory :user_1 , class: User do
    email "user1@email.com"
    firstName "first Name"
    lastName "last Name"
    about "something about this user"
  end

end
