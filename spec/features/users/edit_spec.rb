require "rails_helper"

RSpec.describe do

  before :each do
    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

    visit "/"
    within ".topnav" do
      click_on "Login"
    end

    expect(current_path).to eq("/login")

    fill_in :email, with: "#{@regular_user.email}"
    fill_in :password, with: "#{@regular_user.password}"

    click_on "Submit"
  end

  it "User can edit personal informatiom" do

    click_on "Edit"

    expect(current_path).to eq('/profile/edit')

    fill_in :name, with: 'Spud Nugget'
    fill_in :address, with: '222 Blvd.'
    fill_in :city, with: 'Tucson'
    fill_in :state, with: 'AZ'
    fill_in :zip, with: '80102'

    click_on "Done"

    expect(surrent_path).to eq('/profile')
    expect(page).to have('Spud Nugget')
    expect(page).to have('222 Blvd.')
    expect(page).to have('Tucson')
    expect(page).to have('AZ')
    expect(page).to have('80102')
  end
end
