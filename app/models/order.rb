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
    elsif all_items_status.all?("unfulfilled")
      "Cancelled"
    else
      "Approved"
    end
  end

  def edit_item_orders
    self.item_orders.each do |item|
      item.update(status: "unfulfilled")
    end
  end

  def self.pending
    self.where(status: "pending")
  end

  def self.packaged
    self.where(status: "packaged")
  end

  def self.shipped
    self.where(status: "shipped")
  end

  def self.cancelled
    self.where(status: "cancelled")
  end
  
end
