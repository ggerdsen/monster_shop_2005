
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')
      # User Story 2 Home link:
      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
      # User Story 2 Register Link:
      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
      # User Story 2 Login:
      within 'nav' do
        expect(page).to have_link('Login')
      end

      expect(current_path).to eq('/login')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
        # User Story 2 Cart:
        click_link 'Cart'
        expect(current_path).to eq('/cart')
      end

    end
  end
end
