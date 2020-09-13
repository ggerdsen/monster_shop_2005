RSpec.describe("Order Cancellation") do

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

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
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can cancel an order' do
      order = @default_user.orders.create({
                                          name: "James",
                                          address: "123 Main",
                                          city: "Denver",
                                          state: "CO",
                                          zip: "88888"
                                        })
      
      expect(@paper.inventory).to eq(3)
      
      order.item_orders.create({
        item: @paper,
        quantity: 2,
        price: @paper.price,
        status: "pending"
        })
        
        visit "/orders/#{order.id}"
        
        order.item_orders.each do |item|
          expect(item.status).to eq("pending")
        end

        expect(order.status).to eq("pending")
        
        expect(page).to have_button("Cancel Order")
        
        click_button "Cancel Order"
        
        expect(current_path).to eq("/profile")
        
        order.item_orders.each do |item|
          expect(item.status).to eq("unfulfilled")
        end
        
        expect(order.status).to eq("cancelled")
        
        expect(@paper.inventory).to eq(3)
        
        expect(page).to have_content("Your order has been cancelled")
    end
  end
  
  
  
  
  
  
  
  