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
end
