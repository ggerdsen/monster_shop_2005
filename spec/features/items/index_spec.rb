require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

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
  end
end
