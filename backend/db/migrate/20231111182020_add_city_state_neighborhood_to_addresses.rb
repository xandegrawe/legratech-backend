class AddCityStateNeighborhoodToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string
    add_column :addresses, :neighborhood, :string
  end
end
