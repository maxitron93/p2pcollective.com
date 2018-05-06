class Investment < ApplicationRecord
  belongs_to :active_loan
  belongs_to :user
end
