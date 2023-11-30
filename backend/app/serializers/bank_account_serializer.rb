class BankAccountSerializer < ActiveModel::Serializer
  attributes  :id, :name, :inicial_balance, :current_balance
end