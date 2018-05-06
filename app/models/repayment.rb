class Repayment < ApplicationRecord
  belongs_to :active_loan
  belongs_to :investment
end