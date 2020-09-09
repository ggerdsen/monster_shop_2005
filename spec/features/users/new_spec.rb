require 'rails_helper'

RSpec.describe "As a visitor" do

  it "I can register as a new user from a link in the nav bar" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/profile")

    expect(User.count).to eq(1)
    expect(page).to have_content("You are now registered and logged in")
    expect(page).to have_content("Garrett James Drew-Chris")

  end

  it "Returns me to form if registration form is missing details" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: ""
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/register")

    expect(User.count).to eq(0)
    expect(page).to have_content("Zip can't be blank")

  end

  it "Returns me to form if registration form is missing details" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "passsword"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/register")

    expect(User.count).to eq(0)
    expect(page).to have_content("Password confirmation doesn't match Password")

  end
  # Skipping this test as it is not repopulating the form but only showing the flash message.
  it "does not accept duplicate email addresses" do
    user1 = User.create!(name: "Drew", address: "123", city: "Denver", state: "CO", zip: "80222", email: "blah@gmail.com", password: "123", password_confirmation: "123")

    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "blah@gmail.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(page).to have_field(:name, with: 'Garrett James Drew-Chris')
    expect(page).to have_field(:address, with: '123 Main St.')
    expect(page).to have_field(:city, with: 'Denver')
    expect(page).to have_field(:state, with: 'CO')
    expect(page).to have_field(:zip, with: '80444')

    # #expect(page).to have_content("Garrett James Drew-Chris")
    # expect(page).to have_content("123 Main St.")
    # expect(page).to have_content("Denver")
    # expect(page).to have_content("CO")
    # expect(page).to have_content("80444")


    expect(current_path).to eq("/register")

    expect(page).to have_content("Email has already been taken")

  end
end
