class LoanApplication < ApplicationRecord
  include LicenseUploader::Attachment.new(:license)
  include PaySlipUploader::Attachment.new(:pay_slip)
  belongs_to :user
end