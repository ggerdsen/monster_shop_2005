require 'rails_helper'

RSpec.describe "Adjusting item quantity of cart" do
  describe "As a visitor, when I have items in my cart and I visit my cart " do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @gator_tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 2)
      @zebra_tire = @meg.items.create(name: "Zebraskins", description: "They're mostly Zebra free!", price: 120, image: "https://i.pinimg.com/originals/d2/a2/10/d2a210e2bc35c1fee", inventory: 3)
      @snake_tire = @meg.items.create(name: "Snakeskins", description: "Snakes on a tire!", price: 125, image: "https://i.pinimg.com/originals/0c/d0/00/0cd000894f428500bfcd0483af62911d.jpg", inventory: 4)
      @ostrich_tire = @meg.items.create(name: "Ostrichskins", description: "Absolutely massive!", price: 140, image: "https://i.ebayimg.com/images/g/2i8AAOSwnWFenp6f/s-l640.jpg", inventory: 5)
    end

    it "Next to each item I can increment the count of items I want to purchase" do

      visit "/items/#{@gator_tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@zebra_tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@snake_tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@ostrich_tire.id}"
      click_on "Add To Cart"

      visit "/cart"


      within "#item_quantity-#{@gator_tire.id}" do
        expect(page).to have_link("+")
        expect(page).to have_link("-")
      end

      within "#item_quantity-#{@gator_tire.id}" do
        expect(page).to have_content("1")
        click_on("+")
        expect(page).to have_content("2")
        click_on("+")
        expect(page).to have_content("2")
        click_on("-")
        expect(page).to have_content("1")
        click_on("-")
      end
      expect(page).to_not have_content("#{@gator_tire.name}")
    end
  end
end
