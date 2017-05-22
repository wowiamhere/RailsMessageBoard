require 'rails_helper'

RSpec.describe Message, type: :model do

  it "--------------->should not save message without association<-----------\n" do 
    @user = create(:user_1)
    @message = Message.new title: 'some title', body: 'some body', user_id: nil
    
    expect(@message.save).to be false
    expect{ @message.save! }.to raise_error ActiveRecord::RecordInvalid, /User must exist/
  end

  it "--------------->should not save message without title<-----------\n" do 
    @user = create(:user_1)
    @message = Message.new title: nil, body: 'some body', user_id: @user.id
    
    expect(@message.save).to be false
    expect{ @message.save! }.to raise_error ActiveRecord::RecordInvalid, /Title can't be blank/
  end 

  it "--------------->should not save message without body<-----------\n" do 
    @user = create(:user_1)
    @message = Message.new title: "some title", body: nil, user_id: @user.id
    
    expect(@message.save).to be false
    expect{ @message.save! }.to raise_error ActiveRecord::RecordInvalid, /Body can't be blank/
  end    

end
