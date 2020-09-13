class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
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
