require "rails_helper"

describe "As a registered user" do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @gator_tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 2)
    @zebra_tire = @meg.items.create(name: "Zebraskins", description: "They're mostly Zebra free!", price: 120, image: "https://i.pinimg.com/originals/d2/a2/10/d2a210e2bc35c1fee", inventory: 3)
    @snake_tire = @meg.items.create(name: "Snakeskins", description: "Snakes on a tire!", price: 125, image: "https://i.pinimg.com/originals/0c/d0/00/0cd000894f428500bfcd0483af62911d.jpg", inventory: 4)
    @ostrich_tire = @meg.items.create(name: "Ostrichskins", description: "Absolutely massive!", price: 140, image: "https://i.ebayimg.com/images/g/2i8AAOSwnWFenp6f/s-l640.jpg", inventory: 5)

    @user1 = User.create(name: "Jim Bob",
                        address: "2020 Whiskey River Blvd",
                        city: "Bamaville",
                        state: "AL",
                        zip: "33675",
                        email: "jimbobwoowoo@aol.com",
                        password: "merica4lyfe",
                        role: 0)

    @user2 = User.create(name: "Billy Bob",
                        address: "2020 Whiskey River Blvd",
                        city: "Bamaville",
                        state: "AL",
                        zip: "33675",
                        email: "billybob@aol.com",
                        password: "merica4lyfe!",
                        role: 0)
    end

  it "When I have orders placed in the system I see a link called 'My Orders'" do
    visit "/"
    click_on "Login"
    fill_in "Email", with: "#{@user1.email}"
    fill_in "Password", with: "#{@user1.password}"
    click_button "Submit"

    visit "/items/#{@gator_tire.id}"
    click_on "Add To Cart"
    visit '/cart'
    click_on 'Checkout'

    fill_in "Name", with: "#{@user1.name}"
    fill_in "Address", with: "#{@user1.address}"
    fill_in "City", with: "#{@user1.city}"
    fill_in "State", with: "#{@user1.state}"
    fill_in "Zip", with: "#{@user1.zip}"
    click_on "Create Order"

    visit "/profile"
    expect(page).to have_content("My Orders")
    click_on "My Orders"
    expect(current_path).to eq("/profile/orders")
  end

  it "When I don't have orders placed in the system I can not see a link called 'My Orders'" do
    visit "/"
    click_on "Login"
    fill_in "Email", with: "#{@user2.email}"
    fill_in "Password", with: "#{@user2.password}"
    click_button "Submit"

    visit "/profile"
    expect(page).to_not have_content("My Orders")
  end
end
