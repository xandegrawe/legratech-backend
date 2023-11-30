class BankInvoice < ApplicationRecord
  belongs_to :bank_account
  belongs_to :category, optional: true
  belongs_to :person, optional: true
end
