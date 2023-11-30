class BankAccount < ApplicationRecord
  has_many :bank_invoices
end
