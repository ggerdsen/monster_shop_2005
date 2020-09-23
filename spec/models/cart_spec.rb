require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )
      @bulk_discount = BulkDiscount.create!(merchant_id: @megan.id,
                                            minimum_item_quantity: 1,
                                            percent_discount: 22,
                                            title: "test")
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq({@ogre => 1, @giant => 2})
    end

    it '.total' do
      expect(@cart.total).to eq(93.6)
      @bulk_discount.delete
      expect(@cart.total).to eq(120)
    end

    it '.subtotal()' do
      expect(@cart.subtotal(@ogre)).to eq(20)
      expect(@cart.subtotal(@giant)).to eq(100)
    end

    it ".add_quantity()" do
      @cart.add_item(@ogre)
      expect(@cart.contents[@ogre]).to eq(1)
      @cart.add_quantity(@ogre)
      expect(@cart.contents[@ogre]).to eq(2)
    end

    it ".subtract_quantity()" do
      @cart.add_item(@ogre)
      expect(@cart.contents[@ogre]).to eq(1)
      @cart.add_quantity(@ogre)
      expect(@cart.contents[@ogre]).to eq(2)
      @cart.subtract_quantity(@ogre)
      expect(@cart.contents[@ogre]).to eq(1)
    end

    it ".item_count()" do
      expect(@cart.item_count(@ogre.id)).to eq(1)
      expect(@cart.item_count(@giant.id)).to eq(2)
    end

    it ".out_of_stock?()" do
      expect(@cart.out_of_stock?(@ogre.id)).to eq(false)
      expect(@cart.out_of_stock?(@giant.id)).to eq(true)
    end
    
    it "gives me a subtotal with a discount" do
      @cart.add_item(@hippo.id.to_s)
      expect(@cart.subtotal(@hippo, @bulk_discount)).to eq(39.0)
    end

    it "can modify order" do
      user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo@aol.com", password: "merica4lyfe", role: 1, merchant_id: @megan.id)
      order = user1.orders.create!(id: 1, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @cart.modify(order)
      expect("#{order.item_orders.first.item_id}").to eq(@cart.contents.keys[0])
      expect("#{order.item_orders.last.item_id}").to eq(@cart.contents.keys[1])
      @bulk_discount.delete
      user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo0@aol.com", password: "merica4lyfe", role: 1, merchant_id: @megan.id)
      order = user1.orders.create!(id: 2, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @cart.modify(order)
      expect("#{order.item_orders.first.item_id}").to eq(@cart.contents.keys[0])
      expect("#{order.item_orders.last.item_id}").to eq(@cart.contents.keys[1])
    end
    

    
  end
end
