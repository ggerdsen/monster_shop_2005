require "rails_helper"

RSpec.describe "As a visitor" do

  it "I see 404 error messages when trying to access /merchant, /admin, /profile" do

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist.")
    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist.")
    visit '/profile'
    expect(page).to have_content("The page you were looking for doesn't exist.")

  end
end
