require 'rails_helper'

RSpec.describe "As a merchant employee" do
  describe "When I visit my items page" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @gator_tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @zebra_tire = @meg.items.create!(name: "Zebraskins", description: "No zebras involved!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @snake_tire = @meg.items.create!(name: "Snakeskins", description: "Snakes on a tire!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo@aol.com", password: "merica4lyfe", role: 1, merchant_id: @meg.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    it "has a list of all of my items with their attributes" do

      visit "merchant/items"

      within ".items-#{@gator_tire.id}" do
        expect(page).to have_content("Name: #{@gator_tire.name}")
        expect(page).to have_content("Description: #{@gator_tire.description}")
        expect(page).to have_content("Price: $#{@gator_tire.price}")
        expect(page).to have_css("img[src*='#{@gator_tire.image}']")
        expect(page).to have_content("Status: Active? #{@gator_tire.active?}")
        expect(page).to have_content("Inventory: #{@gator_tire.inventory}")
      end
    end
  end
end
