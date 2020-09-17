require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      User.destroy_all
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end

  describe "As a visitor" do
    it "Will flash a message when I try to checkout" do

      visit "/cart"

      expect(page).to have_content("You must Register or Login in order to checkout")
      expect(page).to have_link("Register")
      expect(page).to have_link("Login")
    end
  end

  describe "I can checkout and have my order profile page populate" do
    it "Will flash a message when I try to checkout" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{regular_user.email}"
      fill_in :password, with: "#{regular_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/profile")

      visit "/items/#{tire.id}"

      click_on "Add To Cart"

      visit "/cart"
      expect(page).to have_link("Checkout")

      click_on "Checkout"

      fill_in :name, with: "#{regular_user.name}"
      fill_in :address, with: "#{regular_user.address}"
      fill_in :city, with: "#{regular_user.city}"
      fill_in :state, with: "#{regular_user.state}"
      fill_in :zip, with: "#{regular_user.zip}"

      click_on "Create Order"

      expect(ItemOrder.last.status).to eq("unfulfilled")

      order = Order.last
      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Your order has been created")
      expect(page).to have_content("Order Number: #{order.id}")
      expect(page).to have_content("Order Placed At: #{order.created_at}")
      expect(page).to have_content("Last Updated At: #{order.updated_at}")
      expect(page).to have_content("Order Status: #{order.status}")
      expect(page).to have_content("Grand Total of Order: $#{order.grandtotal}")

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
