class RenameSupplierToProvider < ActiveRecord::Migration[7.0]
  def change
    rename_table :suppliers, :providers
  end
end
