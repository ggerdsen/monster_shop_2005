require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
      before(:each) do
        @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

        @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
        @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
        @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
        @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
        @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 120)
        @zebra_tire = @meg.items.create(name: "Zebraskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 120)
        @snake_tire = @meg.items.create(name: "Snakeskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 120)
        @ostrich_tire = @meg.items.create(name: "Ostrichskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 120)

        @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
        @chew_toy = @brian.items.create(name: "Chew Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
        @old_toy = @brian.items.create(name: "Old Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
        @new_toy = @brian.items.create(name: "New Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 320)
        @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 210)

        @regular_user = User.create(name: "Jim Bob",
                                    address: "2020 Whiskey River Blvd",
                                    city: "Bamaville",
                                    state: "AL",
                                    zip: "33675",
                                    email: "jimbobwoowoo@aol.com",
                                    password: "merica4lyfe",
                                    role: 0)

        @merchant_user = User.create(name: "Sales Bob",
                                     address: "2020 Whiskey River Blvd",
                                     city: "Bamaville",
                                     state: "AL",
                                     zip: "33675",
                                     email: "salebobwoowoo@aol.com",
                                     password: "mmerica4lyfe",
                                     role: 1)

        @admin_user = User.create(name: "Admin Bob",
                                  address: "2020 Whiskey River Blvd",
                                  city: "Bamaville",
                                  state: "AL",
                                  zip: "33675",
                                  email: "adminbobwoowoo@aol.com",
                                  password: "america4lyfe",
                                  role: 2)

        @order = @regular_user.orders.create(id: 1, name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675")

        ItemOrder.create(status: "pending", order_id: @order.id, item: @pull_toy, quantity: 6, price: @pull_toy.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @chew_toy, quantity: 8, price: @chew_toy.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @old_toy, quantity: 10, price: @old_toy.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @new_toy, quantity: 12, price: @new_toy.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @tire, quantity: 14, price: @tire.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @zebra_tire, quantity: 16, price: @zebra_tire.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @snake_tire, quantity: 18, price: @snake_tire.price)
        ItemOrder.create(status: "pending", order_id: @order.id, item: @ostrich_tire, quantity: 20, price: @ostrich_tire.price)
      end


      it "calculate average review" do
        expect(@chain.average_review).to eq(3.0)
      end

      it "sorts reviews" do
        top_three = @chain.sorted_reviews(3,:desc)
        bottom_three = @chain.sorted_reviews(3,:asc)

        expect(top_three).to eq([@review_1,@review_2,@review_5])
        expect(bottom_three).to eq([@review_3,@review_4,@review_5])
      end

      it 'no orders' do
        expect(@chain.no_orders?).to eq(true)
        order = @regular_user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        order.item_orders.create(status: "pending", item: @chain, price: @chain.price, quantity: 2)
        expect(@chain.no_orders?).to eq(false)
      end

      it "lists the least and most popular items" do
        expect(Item.most_popular_items.to_a).to eql([@ostrich_tire, @snake_tire, @zebra_tire, @tire, @new_toy])
        expect(Item.least_popular_items.to_a).to eql([@pull_toy, @chew_toy, @old_toy, @new_toy, @tire])
      end
      
      it "can increase or decrease a merchant's item quantity" do
        expect(@dog_bone.inventory).to eq(210)
        @dog_bone.modify_item_inventory(@dog_bone, 3, :decrease)
        expect(@dog_bone.inventory).to eq(207)
        @dog_bone.modify_item_inventory(@dog_bone, 3, :decrease)
        expect(@dog_bone.inventory).to eq(204)
        @dog_bone.modify_item_inventory(@dog_bone, 1206, :increase)
      end
    end
end
