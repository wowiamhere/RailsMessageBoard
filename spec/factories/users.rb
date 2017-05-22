FactoryGirl.define do
  
  factory :user_1 , class: User do
    email "user1@email.com"
    firstName "first Name"
    lastName "last Name"
    about "something about this user"
  end

  factory :user_with_messages, class: User do 
    email "user_with_messages@example.com"
    firstName "first Name"
    lastName "last Name"
    about "something about this user"

    factory :messages_for_user do 

      transient do 
        message_count 3
      end

      after(:create) do |user, evaluator| 
        build_list(:message_1, evaluator.message_count, user: user)
      end

    end

  end

end
