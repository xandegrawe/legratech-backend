class ProviderService < ApplicationController

  def initialize(id = nil)
    @id = id
  end

  def index
    customers = Provider.includes(:person).all
  end

  def create(provider_params, person_params, address_params)
    person = find_person_by_email(person_params[:email])
    address = check_address(address_params)

    ActiveRecord::Base.transaction do
      person = Person.create!(person_params) if person.nil?
      address = Address.create!(address_params.merge(person_id: person.id)) if address.present?
      provider = Provider.create!(provider_params.merge(person_id: person.id))
  
      { person: person, address: address, provider: provider, message: "Fornecedor criado com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  def check_address(address_params)
    nil if address_params.values.all?(&:blank?)
    address_params
  end

  def find_person_by_email(email)
    Person.find_by(email: email)
  end
  def show
    select_provider
  end

  def update(provider_params, person_params, address_params)
    provider, person, address = select_provider
    address = check_address(address_params)

    ActiveRecord::Base.transaction do
      person.update!(person_params)
      address.update!(address_params) if address.present?
      provider.update!(provider_params)
      
      { provider: provider, address: address, person: person, message: "Fornecedor atualizado com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  def destroy
    provider, person, address = select_provider
    customer = Customer.find_by(person_id: provider.person_id)

    ActiveRecord::Base.transaction do
      address.destroy! if address.present? || !address.nil?
      provider.destroy!
      person.destroy! if customer.nil?
    
      { message: 'Fornecedor excluído com sucesso' }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message}
    end
  end

  private

  def select_provider
    provider = Provider.find(@id)
    person = provider.person
    address = Address.find_by(person_id: provider.person_id)

    return [provider, person, address]
  end
end