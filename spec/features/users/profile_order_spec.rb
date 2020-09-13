require "rails_helper"

#As a registered user
#When I visit my Profile Orders page
#And I click on a link for order's show page
#My URL route is now something like "/profile/orders/15"
#I see all information about the order, including the following information:
#- the ID of the order
#- the date the order was made
#- the date the order was last updated
#- the current status of the order
#- each item I ordered, including name, description, thumbnail, quantity, price and #subtotal
#- the total quantity of items in the whole order
#- the grand total of all items for that order

RSpec.describe "As a registered user, when I visit my Profile Orders page" do

  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

    visit "/"

    @Order_1 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip)
    visit '/login'

    fill_in :email, with: "#{@regular_user.email}"
    fill_in :password, with: "#{@regular_user.password}"

    click_on "Submit"
  end

  it "Has a link for order's show page" do

    expect(page).to have_link("Orders")

    click_on("Orders")
    expect(current_path).to eq('/profile/orders')

  end

end
require "rails_helper"

#As a registered user
#When I visit my Profile Orders page
#And I click on a link for order's show page
#My URL route is now something like "/profile/orders/15"
#I see all information about the order, including the following information:
#- the ID of the order
#- the date the order was made
#- the date the order was last updated
#- the current status of the order
#- each item I ordered, including name, description, thumbnail, quantity, price and #subtotal
#- the total quantity of items in the whole order
#- the grand total of all items for that order

RSpec.describe "As a registered user, when I visit my Profile Orders page" do

  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

    visit "/"

    visit '/login'

    fill_in :email, with: "#{@regular_user.email}"
    fill_in :password, with: "#{@regular_user.password}"

    click_on "Submit"

    visit "/items/#{@paper.id}"

    click_on("Add To Cart")

    visit "/cart"
    click_on('Checkout')
    fill_in :name, with: @regular_user.name
    fill_in :address, with: @regular_user.address
    fill_in :city, with: @regular_user.city
    fill_in :state, with: @regular_user.state
    fill_in :zip, with: @regular_user.zip

    click_on("Create Order")
    @order_1 = Order.first
  end

  it "Has a link for order's show page" do
    visit "/profile"
    expect(page).to have_link("Orders")

    click_on("Orders")
    expect(current_path).to eq('/profile/orders')

    click_on("Order Number: #{@order_1.id}")
    expect(current_path).to eq("/orders/#{@order_1.id}")
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_1.created_at)
    expect(page).to have_content(@order_1.updated_at)
    expect(page).to have_content(@order_1.approved?)
    expect(page).to have_content(@order_1.grandtotal)
    expect(page).to have_content(@order_1.approved?)
    expect(page).to have_content(@order_1.created_at)
    expect(page).to have_content(@order_1.updated_at)
  end

end
