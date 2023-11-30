class UpdateColumnsBankAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bank_accounts, :balance, :decimal
    add_column :bank_accounts, :inicial_balance, :decimal
    add_column :bank_accounts, :current_balance, :decimal
  end
end
