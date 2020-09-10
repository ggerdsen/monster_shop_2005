require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  before(:each) do
    @regular_user = User.create!(name: "Larry", address: "1236", city: "Denver", state: "CO", zip: "80212", email: "regular_user@email.com", password: "123", role: 0)
    @merchant_user = User.create!(name: "Curly", address: "1235", city: "Denver", state: "CO", zip: "80222", email: "merchant_user@email.com", password: "123", role: 1)
    @admin_user = User.create!(name: "Moe", address: "1234", city: "Denver", state: "CO", zip: "88442", email: "admin_user@email.com", password: "123", role: 2)
  end
  describe "After I login" do
    it "As a regular user, I am redirected to my profile page" do
      
      visit "/merchants"
      
      within '.topnav' do
        click_on "Login"
      end
      
      expect(current_path).to eq("/login")
      
      fill_in :email, with: "#{@regular_user.email}"
      fill_in :password, with: "#{@regular_user.password}"
      
      click_on "Submit"
      
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Success, you are now logged in as #{@regular_user.name}")

    end
    
    xit "As a merchant user, I am redirected to my merchant dashboard page" do

      visit "/merchants"
      
      within '.topnav' do
        click_on "Login"
      end
      
      expect(current_path).to eq("/login")
      
      fill_in :email, with: "#{@regular_user.email}"
      fill_in :password, with: "#{@regular_user.password}"
      
      click_on "Submit"
      
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Success, you are now logged in as #{@regular_user.name}")


    end
    
    xit "As an admin user, I am redirected to my admin dashboard page" do

      visit "/merchants"
      
      within '.topnav' do
        click_on "Login"
      end
      
      expect(current_path).to eq("/login")
      
      fill_in :email, with: "#{@regular_user.email}"
      fill_in :password, with: "#{@regular_user.password}"
      
      click_on "Submit"
      
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Success, you are now logged in as #{@regular_user.name}")


    end
  end
end


# User Story 13, User can Login
#
# As a visitor
# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in