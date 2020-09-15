require 'rails_helper'

RSpec.describe "Merchant Dashboard Show Page" do
  describe "As a merchant employee, when I visit my merchant dashboard ('/merchant') " do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @gator_tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @zebra_tire = @meg.items.create!(name: "Zebraskins", description: "They'll never pop!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo@aol.com", password: "merica4lyfe", role: 1, merchant_id: @meg.id)

      @order1 = @user1.orders.create!(id: 1, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @order1.item_orders.create!(order_id: @order1.id, item: @gator_tire, quantity: 10, price: @gator_tire.price, status: "pending")

      @jim = Merchant.create!(name: "Jim's Bike Shop", address: '12345 Bike Rd.', city: 'LA', state: 'CA', zip: 99876)
      @snake_tire = @jim.items.create!(name: "Snakeskins", description: "Snakes on a tire!", price: 125, image: "https://i.pinimg.com/originals/0c/d0/00/0cd000894f428500bfcd0483af62911d.jpg", inventory: 4)
      @user2 = User.create!(name: "Billy Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "billbobwoowoo@aol.com", password: "merica4lyfe!!", role: 0)

      @order2 = @user2.orders.create!(id: 2, name: "Bob", address: "2020 Cobble Farm Rd", city: "Bamaville", state: "AL", zip: 33675)
      @order2.item_orders.create!(order_id: @order2.id, item: @snake_tire, quantity: 1, price: @snake_tire.price, status: "pending")

      @order3 = @user1.orders.create!(id: 3, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @order3.item_orders.create!(order_id: @order3.id, item: @zebra_tire, quantity: 5, price: @zebra_tire.price, status: "pending")
    end

    it "I can see the name and full address of the merchant I work for" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/merchant"
      within '.merchant-info' do
        expect(page).to have_content(@meg.name)
        expect(page).to have_content(@meg.address)
        expect(page).to have_content(@meg.city)
        expect(page).to have_content(@meg.state)
        expect(page).to have_content(@meg.zip)
      end

      within '.merchant-info' do
        expect(page).to_not have_content(@jim.name)
        expect(page).to_not have_content(@jim.address)
        expect(page).to_not have_content(@jim.city)
        expect(page).to_not have_content(@jim.state)
        expect(page).to_not have_content(@jim.zip)
      end
    end

    it "I see any pending orders for items this merchant sells including id, date, quantity, and value" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/merchant"

      within ".pending-orders-#{@order1.id}" do
        expect(page).to have_link("#{@order1.id}")
        expect(page).to have_content(@order1.created_at)
        expect(page).to have_content(@order1.total_item_count(@meg.id))
        expect(page).to have_content(@order1.total_item_value(@meg.id))
      end
    end

    it "I see a link to view my items and that link takes me to '/merchant/items'" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/merchant"
      click_on "My Items"

      expect(current_path).to eql("/merchant/items")
    end
  end
end
