class CreateBankInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_invoices do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.references :category, optional: true, null: false, foreign_key: true
      t.references :person, optional: true, null: false, foreign_key: true
      t.decimal :amount
      t.integer :status
      t.date :due_date
      t.string :note
      t.integer :current_installment
      t.integer :total_installments

      t.timestamps
    end
  end
end
