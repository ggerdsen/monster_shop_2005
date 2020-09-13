class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_item_count(id)
     item_orders.joins(:item).where(items: {merchant_id: id}).sum(:quantity)
  end

  def total_item_value(id)
     item_orders.joins(:item).where(items: {merchant_id: id}).sum(self.grandtotal)
  end 
  
  def approved?
    all_items_status = item_orders.pluck(:status)
    if all_items_status.any?("pending")
       "Pending"
    else
      "Approved"
    end
  end
end
