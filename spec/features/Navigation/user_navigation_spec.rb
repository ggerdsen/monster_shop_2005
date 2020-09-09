require "rails_helper"

RSpec.describe "As a default user" do
  it "I see the same links as a visitor plus a link to login and logout" do
    it "I do not see a link to log in or register and see a flash confirmation" do
      user_1 = User.create(name: "Jim Bob",
                           address: "2020 Whiskey River Blvd",
                           city: "Bamaville",
                           state: "AL",
                           zip: "33675",
                           email: "jimbobwoowoo@aol.com",
                           password: "merica4lyfe",
                           role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      visit "/home"

      within '.topnav' do
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")

        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end
  end
end
