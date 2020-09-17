require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @employee_user = User.create!(name: "Joe Shmoe", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 1, merchant_id: @meg.id)

    visit '/'
    within ".topnav" do
      click_link("Login")
    end
    fill_in :email, with: @employee_user.email
    fill_in :password, with: @employee_user.password
    click_on "Submit"
    click_link("My Items")
    expect(current_path).to eq("/merchant/items")

  end
  it "See's a link that creates a new item" do

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_link("Create Item")
  end

  it "Has a form for a new item" do

    click_on("Create Item")
    expect(current_path).to eq('/merchant/items/new')

    name = "Chamois Buttr"
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = 25

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory

    click_button "Create Item"
    expect(current_path).to eq('/merchant/items')

    new_item = Item.last
    expect(page).to have_content(new_item.name)
    expect(page).to have_content(new_item.price)
    expect(page).to have_content(new_item.description)

    expect(page).to have_xpath("//img[@src='#{new_item.image}']")
    expect(page).to have_content(new_item.inventory)
  end

  it "See's a flash message if missing any data except an image" do
    Item.destroy_all
    click_on("Create Item")
    expect(current_path).to eq('/merchant/items/new')

    name = "Handl Bars"
    price = 27
    description = "Get A Grip!!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = 25

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: ""
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(current_path).to eq('/merchant/items')
    expect(Item.count).to eq(0)
    expect(page).to have_content("Description can't be blank")
  end
end
