class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :merchant_id,
                        :minimum_item_quantity,
                        :percent_discount
end
