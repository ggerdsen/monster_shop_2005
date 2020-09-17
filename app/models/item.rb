class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        #:image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular_items
    select('items.*, sum(quantity) as total').joins(:item_orders).group('items.id').order('total DESC').limit(5)
  end

  def self.least_popular_items
    select('items.*, sum(quantity) as total').joins(:item_orders).group('items.id').order('total').limit(5)

  end

  def modify_item_inventory(item, quantity, action)
    if action == :decrease
      new_quantity = (item.inventory - quantity)
      item.update(inventory: new_quantity)
    elsif action == :increase
      new_quantity = (item.inventory + quantity)
      item.update(inventory: new_quantity)
    end
  end
end
