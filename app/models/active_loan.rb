class ActiveLoan < ApplicationRecord
  belongs_to :user
  has_many :investments
end
