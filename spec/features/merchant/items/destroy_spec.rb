require 'rails_helper'

RSpec.describe "As a merchant employee" do
  describe "When I visit my items page" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @gator_tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @zebra_tire = @meg.items.create!(name: "Zebraskins", description: "No zebras involved!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @snake_tire = @meg.items.create!(name: "Snakeskins", description: "Snakes on a tire!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo@aol.com", password: "merica4lyfe", role: 1, merchant_id: @meg.id)

      @user2 = User.create!(name: "Billy Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "billbobwoowoo@aol.com", password: "merica4lyfe!!", role: 0)

      @order2 = @user2.orders.create!(id: 2, name: "Bob", address: "2020 Cobble Farm Rd", city: "Bamaville", state: "AL", zip: 33675)
      @order2.item_orders.create!(order_id: @order2.id, item: @snake_tire, quantity: 1, price: @snake_tire.price, status: "pending")

      @order3 = @user1.orders.create!(id: 3, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @order3.item_orders.create!(order_id: @order3.id, item: @zebra_tire, quantity: 5, price: @zebra_tire.price, status: "pending")


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    it "I can click a link or button to delete items that have never been ordered" do

      visit "/merchant/items"

      expect(page).to have_content("Name: #{@gator_tire.name}")
      
      within ".items-#{@snake_tire.id}" do
        expect(page).to_not have_content("Delete Item")
      end
      
      within ".items-#{@zebra_tire.id}" do
        expect(page).to_not have_content("Delete Item")
      end
      
      within ".items-#{@gator_tire.id}" do
        expect(page).to have_content("Delete Item")
        click_on "Delete Item"
      end
      
      expect(current_path).to eq("/merchant/items")
      expect(page).to_not have_content("Name: #{@gator_tire.name}")

      expect(page).to have_content("Item has been deleted")
    end
  end
end
# User Story 44, Merchant deletes an item
#
# As a merchant employee
# When I visit my items page
# I see a button or link to delete the item next to each item that has never been ordered
# When I click on the "delete" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is now deleted
# I no longer see this item on the page