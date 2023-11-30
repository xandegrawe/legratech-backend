class CustomerService < ApplicationController

  def initialize(id = nil)
    @id = id
  end

  def index
    customers = Customer.includes(:person).all
  end

  def create(customer_params, person_params, address_params)
    person = find_person_by_email(person_params[:email])
    address = check_address(address_params)
    ActiveRecord::Base.transaction do
      person = Person.create!(person_params) if person.nil?
      address = Address.create!(address_params.merge(person_id: person.id))
      customer = Customer.create!(customer_params.merge(person_id: person.id))
  
      { person: person, address: address, customer: customer, message: "Cliente criado com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  def find_person_by_email(email)
    Person.find_by(email: email)
  end

  def check_address(address_params)
    nil if address_params.values.all?(&:blank?)
    address_params
  end


  def show
    select_customer
  end

  def update(customer_params, person_params, address_params)
    customer, person, address = select_customer
    address = check_address(address_params)

    ActiveRecord::Base.transaction do
      person.update!(person_params)
      address.update!(address_params)
      customer.update!(customer_params)
      
      { customer: customer, address: address, person: person, message: "Cliente atualizado com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  def destroy
    customer, person, address = select_customer
    provider = Provider.find_by(person_id: customer.person_id)

    ActiveRecord::Base.transaction do
      address.destroy!
      customer.destroy!
      person.destroy! if provider.nil?
    
      { message: 'Cliente excluído com sucesso' }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message}
    end
  end

  private

  def select_customer
    customer = Customer.find(@id)
    person = customer.person
    address = Address.find_by(person_id: customer.person_id)

    return [customer, person, address]
  end
end