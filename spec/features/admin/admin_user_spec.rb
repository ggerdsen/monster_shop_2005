require "rails_helper"

RSpec.describe "As an Admin" do
  it "I see the same links as a regular user plus the a link to my
  admin dashboard ('/admin') and a link to see all users ('/admin/users')" do
    user = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/"

    within '.topnav' do
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")
      expect(page).to have_link("Dashboard")
      expect(page).to have_link("Users")

      expect(page).to_not have_link("Cart")
      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")
    end
  end

  it "I can see all orders in the system, sorted by status, with the order's user profile link, order id, and date created" do
    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    second_user = User.create!(name: "Drew Bob", address: "1 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
    third_user = User.create!(name: "Scooby Doo", address: "133 Main St.", city: "Denver", state: "CO", zip: "80085", email: "third_user@email.com", password: "123", role: 0)
    fourth_user = User.create!(name: "Jerry McGuire", address: "14 Harry St.", city: "Denver", state: "CO", zip: "80085", email: "fourth_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 3)
    order_1.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 12)

    order_2 = second_user.orders.create!(name: second_user.name, address: second_user.address, city: second_user.city, state: second_user.state, zip: second_user.zip, status: "packaged")
    order_2.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 2)
    order_2.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
    order_2.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 32)

    order_3 = third_user.orders.create!(name: third_user.name, address: third_user.address, city: third_user.city, state: third_user.state, zip: third_user.zip, status: "shipped")
    order_3.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 6)
    order_3.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 1)

    order_4 = fourth_user.orders.create!(name: fourth_user.name, address: fourth_user.address, city: fourth_user.city, state: fourth_user.state, zip: fourth_user.zip, status: "cancelled")
    order_4.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
    order_4.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 40)

    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/admin"
    expect(page).to have_link(User.find(order_1.user_id).name)
    expect(page).to have_content(order_1.id)
    expect(page).to have_content(order_1.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_link(User.find(order_2.user_id).name)
    expect(page).to have_content(order_2.id)
    expect(page).to have_content(order_2.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_link(User.find(order_3.user_id).name)
    expect(page).to have_content(order_3.id)
    expect(page).to have_content(order_3.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_link(User.find(order_4.user_id).name)
    expect(page).to have_content(order_4.id)
    expect(page).to have_content(order_4.created_at.strftime("%m-%d-%Y"))
    expect(order_2.user.name).to appear_before(order_1.user.name)
    expect(order_1.user.name).to appear_before(order_3.user.name)
    expect(order_3.user.name).to appear_before(order_4.user.name)
  end

  it "will let an admin change order status from packaged to shipped with link" do
    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    second_user = User.create!(name: "Drew Bob", address: "1 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
    third_user = User.create!(name: "Scooby Doo", address: "133 Main St.", city: "Denver", state: "CO", zip: "80085", email: "third_user@email.com", password: "123", role: 0)
    fourth_user = User.create!(name: "Jerry McGuire", address: "14 Harry St.", city: "Denver", state: "CO", zip: "80085", email: "fourth_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "pending", item: tire, price: tire.price, quantity: 3)
    order_1.item_orders.create!(status: "pending", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "pending", item: pencil, price: pencil.price, quantity: 12)

    order_2 = second_user.orders.create!(name: second_user.name, address: second_user.address, city: second_user.city, state: second_user.state, zip: second_user.zip, status: "packaged")
    order_2.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 2)
    order_2.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
    order_2.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 32)

    order_3 = third_user.orders.create!(name: third_user.name, address: third_user.address, city: third_user.city, state: third_user.state, zip: third_user.zip, status: "shipped")
    order_3.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 6)
    order_3.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 1)

    order_4 = fourth_user.orders.create!(name: fourth_user.name, address: fourth_user.address, city: fourth_user.city, state: fourth_user.state, zip: fourth_user.zip, status: "cancelled")
    order_4.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
    order_4.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 40)

    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/admin"
    within("#packaged") do
      click_on "Ship Order"
    end
    within("#shipped") do
      expect(page).to have_content(order_2.user.name)
    end
    visit "/orders/#{order_2.id}"
    expect(page).to_not have_button("Cancel Order")
  end

  it "can see everything a merchant can see" do
    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "pending", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "pending", item: pencil, price: pencil.price, quantity: 12)
    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/merchants"
    click_on "Mike's Print Shop"
    expect(current_path).to eq("/admin/merchants/#{mike.id}")
    expect(page).to have_content(mike.name)
    expect(page).to have_content(mike.address)
    expect(page).to have_content(mike.city)
    expect(page).to have_content(mike.state)
    expect(page).to have_content(mike.zip)
    expect(page).to have_link(order_1.id)
    expect(page).to have_content(order_1.total_item_count(mike.id))
    expect(page).to have_content(order_1.total_item_value(mike.id))

  end

  it "can disable merchants" do
    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "pending", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "pending", item: pencil, price: pencil.price, quantity: 12)
    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/admin/merchants"
    expect(page).to have_content(mike.name)
    expect(page).to have_content(meg.name)
    expect(page).to have_button("Disable")
    within("#merchant-#{mike.id}") do
      click_on "Disable"
    end
    expect(current_path).to eq("/admin/merchants")
    within("#valid-merchants") do
      expect(page).to have_content(meg.name)
    end
    within("#disabled-merchants") do
      expect(page).to have_content(mike.name)
    end
    expect(page).to have_content("#{mike.name}'s account has been disabled.")
  end

  it "can deactive merchant's items when it is disabled" do

    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                      address: "2020 Whiskey River Blvd",
                      city: "Bamaville",
                      state: "AL",
                      zip: "33675",
                      email: "jimbobwoowoo@aol.com",
                      password: "merica4lyfe",
                      role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "pending", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "pending", item: pencil, price: pencil.price, quantity: 12)
    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/admin/merchants"
    expect(page).to have_content(mike.name)
    expect(page).to have_content(meg.name)
    expect(page).to have_button("Disable")
    within("#merchant-#{mike.id}") do
      click_on "Disable"
    end
    mike.items.each do |item|
      expect(item.active?).to eq(false)
    end
  end
  
  it "can enable merchants" do
    admin = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
    order_1.item_orders.create!(status: "pending", item: paper, price: paper.price, quantity: 1)
    order_1.item_orders.create!(status: "pending", item: pencil, price: pencil.price, quantity: 12)
    visit "/merchants"
    click_on "Login"
    fill_in :password, with: admin.password
    fill_in :email, with: admin.email
    click_on "Submit"
    visit "/admin/merchants"
    expect(page).to have_content(mike.name)
    expect(page).to have_content(meg.name)
    expect(page).to have_button("Disable")
    
    within("#merchant-#{mike.id}") do
      click_on "Disable"
    end
    expect(current_path).to eq("/admin/merchants")
    within("#valid-merchants") do
      expect(page).to have_content(meg.name)
    end
    within("#disabled-merchants") do
      expect(page).to have_content(mike.name)
    end
    expect(page).to have_content("#{mike.name}'s account has been disabled.")
  
    within("#merchant-#{mike.id}") do
      click_on "Enable"
    end
    expect(current_path).to eq("/admin/merchants")
    within("#valid-merchants") do
      expect(page).to have_content(meg.name)
    end
    within("#valid-merchants") do
      expect(page).to have_content(mike.name)
    end
    expect(page).to have_content("#{mike.name}'s account is now enabled.")
  end
end
