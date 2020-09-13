RSpec.describe("Order Cancellation") do

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

      @employee_user = User.create!(name: "Larry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "employee_user@email.com", password: "123", role: 1, merchant_id: @meg.id)
      @default_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/items"
      click_on "Login"
      fill_in :email, with: @default_user.email
      fill_in :password, with: @default_user.password
      click_on "Submit"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can cancel an order' do
      
      expect(@paper.inventory).to eq(3)
        
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"
      order = Order.last
      visit "/orders/#{order.id}"
      
      paper = Item.last
      
      expect(paper.inventory).to eq(1)
      
      order.item_orders.each do |item|
        expect(item.status).to eq("pending")
      end

      expect(order.status).to eq("pending")
      
      expect(page).to have_button("Cancel Order")
      
      click_button "Cancel Order"
      
      expect(current_path).to eq("/profile")
      
      order = Order.last
      
      order.item_orders.each do |item|
        expect(item.status).to eq("unfulfilled")
      end
      
      expect(order.status).to eq("cancelled")
      
      paper = Item.last
      expect(paper.inventory).to eq(3)
      
      expect(page).to have_content("Your order has been cancelled")
    end
  end
  
  
  
  
  
  
  
  