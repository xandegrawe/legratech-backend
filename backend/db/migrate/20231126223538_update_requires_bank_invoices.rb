class UpdateRequiresBankInvoices < ActiveRecord::Migration[7.0]
  def change
    change_column_null :bank_invoices, :person_id, true
    change_column_null :bank_invoices, :category_id, true
  end
end
