require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  before(:each) do
    @tire_shop = Merchant.create(name: "Brian's Tire Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @tire = @tire_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @regular_user = User.create!(name: "Larry", address: "1236", city: "Denver", state: "CO", zip: "80212", email: "regular_user@email.com", password: "123", role: 0)
    @merchant_user = User.create!(name: "Curly", address: "1235", city: "Denver", state: "CO", zip: "80222", email: "merchant_user@email.com", password: "123", role: 1, merchant_id: @tire_shop.id)
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

    it "As a merchant user, I am redirected to my merchant dashboard page" do

      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@merchant_user.email}"
      fill_in :password, with: "#{@merchant_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Success, you are now logged in as #{@merchant_user.name}")

    end

    it "As an admin user, I am redirected to my admin dashboard page" do

      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@admin_user.email}"
      fill_in :password, with: "#{@admin_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/admin")
      expect(page).to have_content("Success, you are now logged in as #{@admin_user.name}")

    end
  end

  describe "When I attempt to login" do
    it "I provide an incorrect password and am denied login access" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@admin_user.email}"
      fill_in :password, with: "wrong_password"

      click_on "Submit"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Your login credentials are incorrect")

    end

    it "I provide an incorrect email and am denied login access" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "g@email.com"
      fill_in :password, with: "#{@admin_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Your login credentials are incorrect")

    end
  end

  describe "As a logged in user" do
    it "When logged in as Admin I take the /login path, i am notified that i am logged in and brought to the appropriate page for my user type" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@admin_user.email}"
      fill_in :password, with: "#{@admin_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/admin")

      visit "/login"

      expect(current_path).to eq("/admin")

      expect(page).to have_content("You are already logged in.")

    end

    it "When logged in as Merchant I take the /login path, i am notified that i am logged in and brought to the appropriate page for my user type" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@merchant_user.email}"
      fill_in :password, with: "#{@merchant_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/merchant")

      visit "/login"

      expect(current_path).to eq("/merchant")

      expect(page).to have_content("You are already logged in.")

    end

    it "When logged in as Default User I take the /login path, i am notified that i am logged in and brought to the appropriate page for my user type" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@regular_user.email}"
      fill_in :password, with: "#{@regular_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/profile")

      visit "/login"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("You are already logged in.")

    end
  end

  describe "As a logged in user I can logout" do
    it "When logged in as Admin I take the /logout I am taken to the welcome page of the site" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@admin_user.email}"
      fill_in :password, with: "#{@admin_user.password}"

      click_on "Submit"

      expect(current_path).to eq("/admin")

      within '.topnav' do
        expect(page).to_not have_content("Cart: 0")
      end

      within '.topnav' do
        click_on "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("You have been logged out")

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "When logged in as Merchant I take the /logout I am taken to the welcome page of the site" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@merchant_user.email}"
      fill_in :password, with: "#{@merchant_user.password}"

      click_on "Submit"

      visit "/items/#{@tire.id}"

      within '.topnav' do
        expect(page).to_not have_content("Cart: 1")
      end

      click_on "Add To Cart"

      within '.topnav' do
        expect(page).to have_content("Cart: 1")
      end

      within '.topnav' do
        click_on "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("You have been logged out")

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "When logged in as Default User I take the /logout I am taken to the welcome page of the site" do
      visit "/merchants"

      within '.topnav' do
        click_on "Login"
      end

      expect(current_path).to eq("/login")

      fill_in :email, with: "#{@regular_user.email}"
      fill_in :password, with: "#{@regular_user.password}"

      click_on "Submit"

      visit "/items/#{@tire.id}"

      within '.topnav' do
        expect(page).to_not have_content("Cart: 1")
      end

      click_on "Add To Cart"

      within '.topnav' do
        expect(page).to have_content("Cart: 1")
      end

      within '.topnav' do
        click_on "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("You have been logged out")

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end
    end

  end
end
#
# User Story 16, User can log out
#
# As a registered user, merchant, or admin
# When I visit the logout path
# I am redirected to the welcome / home page of the site
# And I see a flash message that indicates I am logged out
# Any items I had in my shopping cart are deleted
