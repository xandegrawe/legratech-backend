class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.references :person, null: false, foreign_key: true
      t.string :cpf
      t.string :rg
      t.string :last_name

      t.timestamps
    end
  end
end