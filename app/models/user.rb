class User < ApplicationRecord
  require 'create_profile_and_accounts'
  
  after_create :create_profile_and_accounts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  has_many :accounts
  has_many :loan_applications
  has_many :investments
end
