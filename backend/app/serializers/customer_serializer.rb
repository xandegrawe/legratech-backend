class CustomerSerializer < ActiveModel::Serializer
  attributes  :id, :cpf, :rg, :last_name, :person_id, :name, :phone, :email, :street, :number, :cep, :observation, :address_type, :city, :state, :neighborhood
end
