FactoryGirl.define do

  factory :message_1, class: Message do
    association :user, factory: :user_1
    
    title "some title for a message"
    body "Some message I have for the world to read!"
  end
  
end
