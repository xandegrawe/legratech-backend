class BankInvoiceSerializer < ActiveModel::Serializer
  attributes  :id, :amount, :status, :due_date, :note, :current_installment, :total_installments, :bank_account_id, :category_id, :person_id, :created_at , :category_name, :person_name

  def category_name
    object.category.name if object.category.present?
  end

  def person_name
    object.person.name if object.person.present?
  end
end