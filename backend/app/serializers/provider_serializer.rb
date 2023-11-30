class ProviderSerializer < ActiveModel::Serializer
  attributes  :id, :cnpj, :person_id, :name, :phone, :email, :street, :number, :cep, :observation, :address_type, :city, :state, :neighborhood
end
