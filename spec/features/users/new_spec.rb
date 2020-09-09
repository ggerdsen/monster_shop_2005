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
    
    expect(page).to have_content("You are now registered and logged in")

  end
end


# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password
#
# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in