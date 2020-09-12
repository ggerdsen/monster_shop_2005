require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 120)
      @zebra_tire = @meg.items.create(name: "Zebraskins", description: "They're mostly Zebra free!", price: 120, image: "https://i.pinimg.com/originals/d2/a2/10/d2a210e2bc35c1fee", inventory: 110)
      @snake_tire = @meg.items.create(name: "Snakeskins", description: "Snakes on a tire!", price: 125, image: "https://i.pinimg.com/originals/0c/d0/00/0cd000894f428500bfcd0483af62911d.jpg", inventory: 125)
      @ostrich_tire = @meg.items.create(name: "Ostrichskins", description: "Absolutely massive!", price: 140, image: "https://i.ebayimg.com/images/g/2i8AAOSwnWFenp6f/s-l640.jpg", inventory: 140)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
      @chew_toy = @brian.items.create(name: "Chew Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
      @old_toy = @brian.items.create(name: "Old Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
      @new_toy = @brian.items.create(name: "New Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 210)

      @regular_user = User.create(name: "Jim Bob",
                                  address: "2020 Whiskey River Blvd",
                                  city: "Bamaville",
                                  state: "AL",
                                  zip: "33675",
                                  email: "jimbobwoowoo@aol.com",
                                  password: "merica4lyfe",
                                  role: 0)

      @merchant_user = User.create(name: "Sales Bob",
                                   address: "2020 Whiskey River Blvd",
                                   city: "Bamaville",
                                   state: "AL",
                                   zip: "33675",
                                   email: "salebobwoowoo@aol.com",
                                   password: "mmerica4lyfe",
                                   role: 1)

      @admin_user = User.create(name: "Admin Bob",
                                address: "2020 Whiskey River Blvd",
                                city: "Bamaville",
                                state: "AL",
                                zip: "33675",
                                email: "adminbobwoowoo@aol.com",
                                password: "america4lyfe",
                                role: 2)

      @order = Order.create(id: 1, name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675")

      ItemOrder.create(order_id: @order.id, item: @pull_toy, quantity: 6, price: @pull_toy.price)
      ItemOrder.create(order_id: @order.id, item: @chew_toy, quantity: 8, price: @chew_toy.price)
      ItemOrder.create(order_id: @order.id, item: @old_toy, quantity: 10, price: @old_toy.price)
      ItemOrder.create(order_id: @order.id, item: @new_toy, quantity: 12, price: @new_toy.price)
      ItemOrder.create(order_id: @order.id, item: @tire, quantity: 14, price: @tire.price)
      ItemOrder.create(order_id: @order.id, item: @zebra_tire, quantity: 16, price: @zebra_tire.price)
      ItemOrder.create(order_id: @order.id, item: @snake_tire, quantity: 18, price: @snake_tire.price)
      ItemOrder.create(order_id: @order.id, item: @ostrich_tire, quantity: 20, price: @ostrich_tire.price)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      # expect(page).to have_link(@dog_bone.name)
      # expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      # within "#item-#{@dog_bone.id}" do
      #   expect(page).to have_link(@dog_bone.name)
      #   expect(page).to have_content(@dog_bone.description)
      #   expect(page).to have_content("Price: $#{@dog_bone.price}")
      #   expect(page).to have_content("Inactive")
      #   expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
      #   expect(page).to have_link(@brian.name)
      #   expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      # end
    end

    it "As any kind of user in the system I see all items except disabled items" do

      visit "/items"

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@pull_toy.name)

      expect(page).to have_no_link(@dog_bone.name)

      visit '/login'

      fill_in :email, with: @regular_user.email
      fill_in :password, with: @regular_user.password

      click_on 'Submit'

      visit "/items"

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@pull_toy.name)

      expect(page).to have_no_link(@dog_bone.name)

      click_on 'Logout'

      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password

      click_on 'Submit'

      visit "/items"

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@pull_toy.name)

      expect(page).to have_no_link(@dog_bone.name)

      click_on 'Logout'

      visit '/login'

      fill_in :email, with: @admin_user.email
      fill_in :password, with: @admin_user.password

      click_on 'Submit'

      visit "/items"

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@pull_toy.name)

      expect(page).to have_no_link(@dog_bone.name)
    end

    it "As any kind of user, when I visit ('/items') I see an area with statistics
      including the top 5 most and least popular items and their quantity bought" do

      visit "/items"

      within("#most-popular-items") do
        expect(@ostrich_tire.name).to appear_before(@snake_tire.name)
        expect(@zebra_tire.name).to appear_before(@tire.name)
      end

      within("#least-popular-items") do
        expect(@pull_toy.name).to appear_before(@chew_toy.name)
        expect(@old_toy.name).to appear_before(@new_toy.name)
      end

      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password

      click_on 'Submit'

      visit "/items"

      within("#most-popular-items") do
        expect(@ostrich_tire.name).to appear_before(@snake_tire.name)
        expect(@zebra_tire.name).to appear_before(@tire.name)
      end

      within("#least-popular-items") do
        expect(@pull_toy.name).to appear_before(@chew_toy.name)
        expect(@old_toy.name).to appear_before(@new_toy.name)
      end

      click_on 'Logout'

      visit '/login'

      fill_in :email, with: @admin_user.email
      fill_in :password, with: @admin_user.password

      click_on 'Submit'

      visit "/items"

      within("#most-popular-items") do
        expect(@ostrich_tire.name).to appear_before(@snake_tire.name)
        expect(@zebra_tire.name).to appear_before(@tire.name)
      end

      within("#least-popular-items") do
        expect(@pull_toy.name).to appear_before(@chew_toy.name)
        expect(@old_toy.name).to appear_before(@new_toy.name)
      end
    end
  end
end
