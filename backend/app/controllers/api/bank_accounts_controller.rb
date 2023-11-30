class Api::BankAccountsController < ApplicationController
  def index
    bank_accounts = bank_account_service.index
    bank_account_data = bank_accounts.map do |bank_account|
      {
        id: bank_account.id,
        name: bank_account.name,
        inicial_balance: bank_account.inicial_balance
      }
    end
  
    render json: bank_account_data
  end

  def create
    bank_account = bank_account_service.create(bank_account_params)
    render json: bank_account
  end

  def destroy
    result = bank_account_service.destroy(selected_bank_account)
    
    if result[:error]
      render json: { errors: "Falha na exclusão: #{result[:error]}" }, status: :unprocessable_entity
    else
      render json: { message: result[:message] }
    end
  end

  private

  def bank_account_params
    params.require(:bank_account).permit(:name, :inicial_balance, :current_balance)
  end

  def selected_bank_account
    bank_account = BankAccount.find(params[:id])
  end

  def bank_account_service
    @bank_account_service ||= BankAccountService.new
  end
end
