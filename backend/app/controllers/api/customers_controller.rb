class Api::CustomersController < ApplicationController
  def index
    customers = customer_service.index
    customer_data = customers.map do |customer|
      {
        id: customer.id,
        name: customer.person.name,
        last_name: customer.last_name,
        phone: customer.person.phone
      }
    end
  
    render json: customer_data
  end

  def create
    result = customer_service.create(customer_params, person_params, address_params)

    if result[:error]
      render json: { errors: "Falha na criação: #{result[:error]}" }, status: :unprocessable_entity
    else
      customer = result[:customer]
      render json: { id: customer.id, name: customer.person.name, last_name: customer.last_name, phone: customer.person.phone} , status: :created
    end
  end

  def show
    customer, person, address = customer_service.show
    render json: { customer: customer, address: address, person: person }
  end

  def update
    result = customer_service.update(customer_params, person_params, address_params)

    if result[:error]
      render json: { errors: "Falha na atualização: #{result[:error]}" }, status: :unprocessable_entity
    else
      render json: result, status: :ok
    end
  end

  def destroy
    result = customer_service.destroy
    
    if result[:error]
      render json: { errors: "Falha na exclusão: #{result[:error]}" }, status: :unprocessable_entity
    else
      render json: { message: result[:message] }
    end
  end
 
  private

  def customer_service
    @customer_service ||= CustomerService.new(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :email, :phone)
  end

  def address_params
    params.require(:address).permit(:street, :number, :cep, :observation, :address_type, :city, :state, :neighborhood)
  end

  def customer_params
    params.require(:customer).permit(:cpf, :rg, :last_name, :person_id)
  end
end
