require 'rails_helper'

describe User do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
  end

  describe "roles" do
    it "can be created as a default user" do
      user = User.create(name: "Jim Bob",
                           address: "2020 Whiskey River Blvd",
                           city: "Bamaville",
                           state: "AL",
                           zip: "33675",
                           email: "jimbobwoowoo@aol.com",
                           password: "merica4lyfe",
                           role: 0)

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy

    end
  end
end
