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

  it "Has a form for a new item" do
    click_on("Edit Item")
    expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

    name = "Chamois Butter"
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = 25
    
    expect(find_field('Name').value).to eq "#{@tire.name}"
    expect(find_field('Price').value).to eq "#{@tire.price}"
    expect(find_field('Description').value).to eq "#{@tire.description}"
    expect(find_field('Image').value).to eq("#{@tire.image}")
    expect(find_field('Inventory').value).to eq "#{@tire.inventory}"
    
    
    fill_in :name, with: ""
    fill_in :price, with: ""
    fill_in :description, with: ""
    fill_in :image, with: image_url
    fill_in :inventory, with: ""

    click_button "Submit Edits"

    expect(page).to have_content("Name can't be blank, Description can't be blank, Price can't be blank, Price is not a number, and Inventory can't be blank")
    expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory

    click_button "Submit Edits"

    expect(current_path).to eq('/merchant/items')
    
    expect(page).to have_content("Item has been updated")
    expect(page).to have_content(name)
    expect(page).to have_content(price)
    expect(page).to have_content(description)
    expect(page).to have_content(inventory)
  end
end