require "rails_helper"

RSpec.describe "As a merchant employee I see the same links as a regular user" do

  before :each do
    @employee = User.create(name: "Jim Bob",
      address: "2020 Whiskey River Blvd",
      city: "Bamaville",
      state: "AL",
      zip: "33675",
      email: "jimbobwoowoo@aol.com",
      password: "merica4lyfe",
      role: 1)


    end

  it "I see the same links as a regular user and a link to my merchant dashboard" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)

    visit "/"

    expect(page).to have_link("Home")
    expect(page).to have_link("All Merchants")
    expect(page).to have_link("Profile")
    expect(page).to have_link("Logout")
    expect(page).to have_link("Merchant Dashboard")

  end
end
