class BankAccountService < ApplicationController
  def index
    bank_accounts = BankAccount.all
  end

  def create(bank_account_params)
    inicial_balance = formated_balance(bank_account_params[:inicial_balance])
    name = bank_account_params[:name]
    bank_account = BankAccount.new(name: name, inicial_balance: inicial_balance)
    bank_account.save!
    bank_account
  end

  def formated_balance(inicial_balance)
    formated_balance = inicial_balance.gsub(/(?<=\d)\.(?=\d{3}(?:,|$))/, '')
    formated_balance = formated_balance.gsub(',', '.')
    formated_balance.to_f
  end

  def show
    bank_account = BankAccount.find(params[:id])
  end

  # def update(customer_params, person_params, address_params)
  #   customer, person, address = select_customer
  #   address = check_address(address_params)

  #   ActiveRecord::Base.transaction do
  #     person.update!(person_params)
  #     address.update!(address_params)
  #     customer.update!(customer_params)
      
  #     { customer: customer, address: address, person: person, message: "Cliente atualizado com sucesso" }
  #   rescue ActiveRecord::RecordInvalid => e
  #     { error: e.message }
  #   end
  # end

  def destroy(bank_account)
    bank_invoices = BankInvoice.where(bank_account_id: bank_account.id)

    ActiveRecord::Base.transaction do
      bank_invoices.destroy_all
      bank_account.destroy!
    
      { message: 'Conta excluída com sucesso' }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message}
    end
  end

  private 

  def select_bank_account(params)
    bank_account = BankAccount.find(params[:id])
  end
end