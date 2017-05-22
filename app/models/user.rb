class User < ApplicationRecord

  has_many :comments
  
  before_save { self.email = email.downcase }

  validates :email, 
    presence: true,
    uniqueness: { case_sensitive: false, message: "Email Already Taken!" }

  validates :firstName, presence: true

  validates :lastName, presence: true

  validates :about, presence: true

end
