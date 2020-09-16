require "rails_helper"

RSpec.describe "As an Admin" do
  it "I see the same links as a regular user plus the a link to my
  admin dashboard ('/admin') and a link to see all users ('/admin/users') that has valid routes" do
    user = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    second_user = User.create!(name: "Drew Bob", address: "1 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
    third_user = User.create!(name: "Scooby Doo", address: "133 Main St.", city: "Denver", state: "CO", zip: "80085", email: "third_user@email.com", password: "123", role: 0)
    fourth_user = User.create!(name: "Jerry McGuire", address: "14 Harry St.", city: "Denver", state: "CO", zip: "80085", email: "fourth_user@email.com", password: "123", role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/admin"
    click_on "Users"
    expect(current_path).to eq("/admin/users")
    expect(page).to have_link(user.name)
    expect(page).to have_link(regular_user.name)
    expect(page).to have_link(second_user.name)
    expect(page).to have_link(third_user.name)
    expect(page).to have_link(fourth_user.name)
    expect(page).to have_content(user.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_content(regular_user.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_content(second_user.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_content(third_user.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_content(fourth_user.created_at.strftime("%m-%d-%Y"))
    within("#user-#{user.id}") do
      expect(page).to have_content("Admin")
    end
    within("#user-#{regular_user.id}") do
      expect(page).to have_content("Default")
    end
    within("#user-#{second_user.id}") do
      expect(page).to have_content("Default")
    end
    within("#user-#{third_user.id}") do
      expect(page).to have_content("Default")
    end
    within("#user-#{fourth_user.id}") do
      expect(page).to have_content("Merchant")
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user)
    visit "/admin/users"
    expect(page).to have_content("404")
  end

  it "I see the same links as a regular user plus the a link to my
  admin dashboard ('/admin') and a link to see all users ('/admin/users') that has valid routes" do
    user = User.create(name: "Jim Bob Manager Extraordinaire",
                       address: "2020 Whiskey River Blvd",
                       city: "Bamaville",
                       state: "AL",
                       zip: "33675",
                       email: "jimbobwoowoo@aol.com",
                       password: "merica4lyfe",
                       role: 2)
    regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
    second_user = User.create!(name: "Drew Bob", address: "1 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
    third_user = User.create!(name: "Scooby Doo", address: "133 Main St.", city: "Denver", state: "CO", zip: "80085", email: "third_user@email.com", password: "123", role: 0)
    fourth_user = User.create!(name: "Jerry McGuire", address: "14 Harry St.", city: "Denver", state: "CO", zip: "80085", email: "fourth_user@email.com", password: "123", role: 1)
    order_1 = second_user.orders.create!(name: second_user.name, address: second_user.address, city: second_user.city, state: second_user.state, zip: second_user.zip)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/admin/users"
    click_on "Drew Bob"
    expect(page).to have_content(second_user.name)
    expect(page).to have_content(second_user.email)
    expect(page).to have_content(second_user.address)
    expect(page).to have_content(second_user.city)
    expect(page).to have_content(second_user.state)
    expect(page).to have_content(second_user.zip)
    expect(page).to have_link("#{second_user.name}'s Orders")
    expect(page).to_not have_link("Edit")
    expect(page).to_not have_link("Edit Password")
    click_on "#{second_user.name}'s Orders"
    expect(current_path).to eq("/admin/users/#{second_user.id}/orders")
    expect(page).to have_content(second_user.orders.first.name)

  end
end
