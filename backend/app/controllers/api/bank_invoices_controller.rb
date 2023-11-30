class Api::BankInvoicesController < ApplicationController
  def index
    result = bank_invoice_service.index
    render json: result
  end

  def show
    bank_invoice = bank_invoice_service.show(params[:id])
    render json: bank_invoice
  end

  def create
    result = bank_invoice_service.create(bank_invoice_params)

    if result[:error]
      render json: { errors: "Falha na criação: #{result[:error]}" }, status: :unprocessable_entity
    else
      bank_invoice = result[:bank_invoice]
      render json: bank_invoice, status: :created
    end
  end

  def calculate_summary
    current_balance, income, expenses = bank_invoice_service.calculate_summary(params)
    render json: { current_balance: current_balance, income: income, expenses: expenses }
  end

  def update
    result = bank_invoice_service.update(params)
    
    if result[:error]
      render json: { errors: "Falha na atualização: #{result[:error]}" }, status: :unprocessable_entity
    else
      bank_invoice = result[:bank_invoice]
      render json: bank_invoice, status: :ok
    end
  end

  def destroy
    bank_invoice = bank_invoice_service.destroy(params)
    render json: bank_invoice
  end

  private

  def bank_invoice_params
    params.require(:bank_invoice).permit(:name, :id, :amount, :status, :due_date, :note, :current_installment, :total_installments, :bank_account_id, :category_id, :person_id)
  end

  def bank_invoice_service
    @bank_invoice_service ||= BankInvoiceService.new
  end
end
