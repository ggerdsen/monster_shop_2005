require "rails_helper"

RSpec.describe "Order Packaged" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @merchant_user = User.create!(name: "Joe Shmoe", address: "4321 Active St.", city: "BPo", state: "CT", zip: "80345", email: "merchant_user@email.com", password: "1234", role: 1, merchant_id: @meg.id)

      @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0, merchant_id: nil)


      visit "/items"
      click_on "Login"
      fill_in :email, with: @regular_user.email
      fill_in :password, with: @regular_user.password
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

      fill_in :name, with:@regular_user.name
      fill_in :address, with:@regular_user.address
      fill_in :city, with:@regular_user.city
      fill_in :state, with:@regular_user.state
      fill_in :zip, with:@regular_user.zip

      click_button "Create Order"

      within ".topnav" do
        click_link "Logout"
      end
      @order = Order.first
    end

  it ("Merchant User will change status to packaged") do
    ItemOrder.destroy_all
    @order = Order.first
    @order.item_orders.create!(status: "unfulfilled", item: @tire, price: @tire.price, quantity: 3)

    visit "/merchants"
    click_on "Login"
    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password
    click_on "Submit"

    visit "/merchant/orders/#{@order.id}"
    expect(page).to have_button("Fulfill Item")

    save_and_open_page
    click_on("Fulfill Item", match: :first)
    binding.pry


    #expect(page).to have_content("packaged")

    click_on "Login"

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password
    click_on "Submit"
    visit "/merchant/orders/#{@order.id}"

    expect(page).to have_button("Fulfill Item")
    expect(@order.status).to eq("pending")

    click_on("Fulfill Item", match: :first)
    @order = Order.first
    expect(page).to_not have_button("Fulfill Item")
    expect(page).to have_content("Item has been fulfilled")
    expect(@order.status).to eq("packaged")
  end

end
