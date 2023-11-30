class Api::ProvidersController < ApplicationController
  def index
    providers = Provider.includes(:person).all
    provider_data = providers.map do |provider|
      {
        id: provider.id,
        cnpj: provider.cnpj,
        name: provider.person.name,
        phone: provider.person.phone
      }
    end
    render json: provider_data
  end

  def create
    result = provider_service.create(provider_params, person_params, address_params)

    if result[:error]
      render json: { errors: "Falha na criação: #{result[:error]}" }, status: :unprocessable_entity
    else
      provider = result[:provider]
      render json: { id: provider.id, name: provider.person.name, cnpj: provider.cnpj, phone: provider.person.phone} , status: :created
    end
  end

  def show
    provider, person, address = provider_service.show
    render json: { provider: provider, address: address, person: person }
  end

  def update
    provider = Provider.find(params[:id])
    provider.update!(customer_params)
    render json: provider
  end

  def destroy
    result = provider_service.destroy
    
    if result[:error]
      render json: { errors: "Falha na exclusão: #{result[:error]}" }, status: :unprocessable_entity
    else
      render json: { message: result[:message] }
    end
  end

  private

  def provider_service
    @provider_service ||= ProviderService.new(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :email, :phone)
  end

  def address_params
    params.require(:address).permit(:street, :number, :cep, :observation, :address_type, :city, :state, :neighborhood)
  end

  def provider_params
    params.require(:provider).permit(:cnpj, :person_id)
  end
end
