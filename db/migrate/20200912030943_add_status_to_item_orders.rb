class AddStatusToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :status, :string
  end
end
