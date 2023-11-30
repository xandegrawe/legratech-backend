class BankInvoiceService < ApplicationController
  def index
    bank_invoices = BankInvoice.all.left_outer_joins(:category, :person)
    formatted_invoices = bank_invoices.map do |invoice|
      category_name = invoice.category&.name
      person_name = invoice.person&.name
      invoice.attributes.merge({
        'amount' => formated_balance_view(invoice.amount),
        'status' => invoice.status.to_s,
        'category_name' => category_name,
        'person_name' => person_name,
      })
    end
    formatted_invoices
  end

  def create(bank_invoice_params)
    if bank_invoice_params[:bank_account_id].nil?
      return { error: "Conta bancária não pode ser nula" }
    end

    bank_invoice_params[:amount] = formated_balance_db(bank_invoice_params[:amount])
    bank_invoice_params[:status] = convert_status(bank_invoice_params[:status])

    ActiveRecord::Base.transaction do
      bank_invoice = BankInvoice.new(bank_invoice_params)
      bank_invoice.save!
      
      { bank_invoice: bank_invoice, message: "Fatura criada com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  def formated_balance_db(balance)
    formated_balance = balance.gsub(/(?<=\d)\.(?=\d{3}(?:,|$))/, '')
    formated_balance = formated_balance.gsub(',', '.')
    formated_balance.to_f
  end

  def formated_balance_view(balance)
    formatted_balance = '%.2f' % balance.to_f
    formatted_balance.gsub!('.', ',')
    inteiro, decimal = formatted_balance.split(',')
    partes = inteiro.chars.to_a.reverse.each_slice(3).map(&:join)
    inteiro = partes.map(&:reverse).reverse.join('.')
    formatted_balance = [inteiro, decimal].join(',')
  
    formatted_balance
  end
  
  def show(bank_invoice_id)
    bank_invoice = BankInvoice.includes(:category, :person).find(bank_invoice_id)
    additional_attributes = {
      'category_name' => bank_invoice.category&.name,
      'person_name' => bank_invoice.person&.name,
      'amount' => formated_balance_view(bank_invoice.amount),
      'status' => bank_invoice.status.to_s,
    }
  
    bank_invoice.attributes.merge(additional_attributes)
  end

  def convert_status(status)
    if status == "Entrada"
      return '0'
    elsif status == "Saída"
      return '1'
    else
      return '2'
    end
  end

  def transform_date(date)
    date.strftime("%d de %b de %Y, às %H:%M")
  end

  def update(bank_invoice_params)
    filter_params = bank_invoice_params['bank_invoice']
    filter_params[:category_id] = filter_params[:category_id].blank? ? nil : filter_params[:category_id]
    filter_params[:person_id] = filter_params[:person_id].blank? ? nil : filter_params[:person_id]
    filter_params[:amount] = formated_balance_db(filter_params[:amount])
    filter_params[:status] = convert_status(filter_params[:status])
    filter_params[:id] = bank_invoice_params[:id].to_i

    bank_invoice = BankInvoice.find_by(id: filter_params[:id])
    return { error: "Fatura não encontrada" } unless bank_invoice
  
    ActiveRecord::Base.transaction do
      bank_invoice.update!(category_id: filter_params[:category_id], person_id: filter_params[:person_id], amount: filter_params[:amount], status: filter_params[:status], note: filter_params[:note])
      { bank_invoice: bank_invoice, message: "Fatura atualizada com sucesso" }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end
  
  def calculate_summary(params)
    return ["-", "-", "-"] if params[:id].nil? || params[:id].blank?
    bank_account = BankAccount.find(params[:id].to_i)
    invoices = BankInvoice.where(bank_account_id: bank_account.id)
    bank_inicial_formated = formated_balance_view(bank_account.inicial_balance)
    return [bank_inicial_formated, '-', '-'] if invoices.nil? || invoices.blank?
    expenses = invoices.where(status: 1).sum(:amount)
    income = invoices.where(status: 0).sum(:amount)
    current_balance =  bank_account.inicial_balance.to_i + income - expenses
    current_balance = bank_account.inicial_balance if current_balance.nil? || current_balance.blank?

    expenses = formated_balance_view(expenses)
    income = formated_balance_view(income)
    current_balance = formated_balance_view(current_balance)

    [current_balance, income, expenses]
  end

  def destroy(params)
    bank_invoice = select_invoice_account(params)

    ActiveRecord::Base.transaction do
      bank_invoice.destroy!
      
      { message: 'Fatura excluída com sucesso' }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end

  private 

  def select_invoice_account(params)
    bank_invoice = BankInvoice.find(params[:id])
  end
end