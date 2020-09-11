require "rails_helper"

RSpec.describe "As a user" do

  before :each do
    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    @second_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
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
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    fill_in :password_confirmation, with: @regular_user.password

    click_on "Submit"

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Spud Nugget')
    expect(page).to have_content('222 Blvd.')
    expect(page).to have_content('Tucson')
    expect(page).to have_content('AZ')
    expect(page).to have_content('80102')
  end

  skip it "Will let user know if a field is empty" do

    click_on "Edit"

    expect(current_path).to eq('/profile/edit')

    fill_in :name, with: 'Spud Nugget'
    fill_in :address, with: '222 Blvd.'
    fill_in :city, with: 'Tucson'
    fill_in :state, with: ''
    fill_in :zip, with: '80102'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password

    click_on "Submit"

    expect(current_path).to eq('/profile/edit')
    expect(page).to have_content("Please fill in the following fields: ['state']")

  end

  it "will let you edit password when filling out correctly" do

    visit '/profile'
    click_on 'Edit Password'
    expect(current_path).to eq('/profile/password')
    fill_in :password, with: "new_password"
    fill_in :password_confirmation, with: "new_password"
    click_on "Submit"
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been updated")


  end

  it "will let you give error message when edit password form is incorrectly filled" do

    visit '/profile'
    click_on 'Edit Password'
    expect(current_path).to eq('/profile/password')
    fill_in :password, with: "new_password"
    fill_in :password_confirmation, with: "new_passworddd"
    click_on "Submit"
    expect(current_path).to eq('/profile/password')
    expect(page).to have_content("Password confirmation doesn't match Password")

  end

  it "will not let you change your email address to one already in use" do

    visit '/profile'
    click_on 'Edit'
    fill_in :name, with: 'Spud Nugget'
    fill_in :address, with: '222 Blvd.'
    fill_in :city, with: 'Tucson'
    fill_in :state, with: 'AZ'
    fill_in :zip, with: '80102'
    fill_in :email, with: @second_user.email
    fill_in :password, with: @regular_user.password
    fill_in :password_confirmation, with: @regular_user.password
    click_on "Submit"
    expect(current_path).to eq('/profile/edit')
    expect(page).to have_content("Email has already been taken")

  end

end
