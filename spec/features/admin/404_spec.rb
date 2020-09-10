require "rails_helper"

describe "as an admin" do
  before :each do
      @user = User.create(name: "Jim Bob",
        address: "2020 Whiskey River Blvd",
        city: "Bamaville",
        state: "AL",
        zip: "33675",
        email: "jimbobwoowoo@aol.com",
        password: "merica4lyfe",
        role: 2)
    end
  it 'does not allow default user to see merchant path or cart path' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant/dashboard"

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/cart'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
