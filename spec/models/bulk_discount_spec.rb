require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  
  describe "validations" do
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :minimum_item_quantity }
    it { should validate_presence_of :percent_discount }
  end
  
  describe "relationships" do
    it {should belong_to :merchant}
  end
  
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      @bulk_discount = BulkDiscount.create!(merchant_id: @megan.id,
                                            minimum_item_quantity: 1,
                                            percent_discount: 22,
                                            title: "test")
    end
    
    it "meet_minimum?" do
      expect(@bulk_discount.meet_minimum?(1, 2)).to eq(false)
    end
    
    it "get_best" do
      expect(BulkDiscount.get_best(@megan.id, @ogre, 3)).to eq(@bulk_discount)
    end
    
    it "percent_of_total" do
      expect(@bulk_discount.percent_of_total).to eq(0.78)
    end
  end
end
