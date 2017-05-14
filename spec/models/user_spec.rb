require 'rails_helper'

RSpec.describe User, type: :model do

  describe "\n------------>User VALIDATION<------------\n" do 

    it "\n------------>ensures email presence<-------------\n" do 
      @user = build(:user_1)
      @user.email = nil

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /Email can't be blank/
    end

    it "\n------------>Ensures email uniqueness<-------------\n" do 
      @user1 = create(:user_1)
      @user = build(:user_1)

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /Email Already Taken!/
    end    

    it "\n------------>Ensures firstName present<-------------\n" do 
      @user = build(:user_1)
      @user.firstName = nil

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /Firstname can't be blank/
    end

    it "\n------------>Ensures lastName present<-------------\n" do 
      @user = build(:user_1)
      @user.lastName = nil

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /Lastname can't be blank/
    end

    it "\n------------>Ensures about present<-------------\n" do 
      @user = build(:user_1)
      @user.about = nil

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /About can't be blank/
    end                



  end

end