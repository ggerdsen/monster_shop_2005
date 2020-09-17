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
    @order_1 = @regular_user.orders.create!(name: @regular_user.name, address: @regular_user.address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip)
    @item_order1 = @order_1.item_orders.create!(status: "unfulfilled", item: @tire, price: @tire.price, quantity: 3)
    @item_order2 = @order_1.item_orders.create!(status: "unfulfilled", item: @paper, price: @paper.price, quantity: 3)


    visit "/items"
    click_on "Login"
    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password
    click_on "Submit"
  end

  it "can view my merchant items on my order show page that are in a user's item order" do
    visit "/merchant/orders/#{@order_1.id}"
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to_not have_content(@paper.name)
    expect(page).to have_content(@tire.name)
    expect(page).to have_xpath("//img[@src='#{@tire.image}']")
    expect(page).to have_content(@tire.price)
    expect(page).to have_content(@tire.price)
    expect(page).to have_content(@item_order1.quantity)
  end

  it "can fulfill part of an order" do
    visit "/merchant/orders/#{@order_1.id}"
    within("#item-order-for-item-#{@tire.id}") do
      click_on "Fulfill Item"
    end
    expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
    expect(page).to have_content("Item has been fulfilled")
    expect(page).to have_content("Item Fulfilled")
    expect(ItemOrder.all.first.item.inventory).to eq(9)
  end

  it "can't fulfill an order if quantity in item_order is greater than item inventory" do
    @item_order1.update(quantity: 4524)
    visit "/merchant/orders/#{@order_1.id}"
    expect(page).to_not have_button("Fulfill Item")
    expect(page).to have_content("You cannot fulfill this item.")
  end
end
