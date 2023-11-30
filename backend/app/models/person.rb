class Person < ApplicationRecord
  has_one :customer
  has_one :supplier
  has_many :addresses
  has_many :bank_invoices
end
