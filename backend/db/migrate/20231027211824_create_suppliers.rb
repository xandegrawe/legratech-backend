class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.references :person, null: false, foreign_key: true
      t.string :cnpj

      t.timestamps
    end
  end
end
