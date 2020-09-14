# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Merchant.destroy_all
ItemOrder.destroy_all
Order.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

admin = User.create(name: "Jim Bob Manager Extraordinaire",
                   address: "2020 Whiskey River Blvd",
                   city: "Bamaville",
                   state: "AL",
                   zip: "33675",
                   email: "jimbobwoowoo@aol.com",
                   password: "merica4lyfe",
                   role: 2)
mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
second_user = User.create!(name: "Drew Bob", address: "1 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "second_user@email.com", password: "123", role: 0)
third_user = User.create!(name: "Scooby Doo", address: "133 Main St.", city: "Denver", state: "CO", zip: "80085", email: "third_user@email.com", password: "123", role: 0)
fourth_user = User.create!(name: "Jerry McGuire", address: "14 Harry St.", city: "Denver", state: "CO", zip: "80085", email: "fourth_user@email.com", password: "123", role: 0)
order_1 = regular_user.orders.create!(name: regular_user.name, address: regular_user.address, city: regular_user.city, state: regular_user.state, zip: regular_user.zip)
order_1.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 3)
order_1.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
order_1.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 12)

order_2 = second_user.orders.create!(name: second_user.name, address: second_user.address, city: second_user.city, state: second_user.state, zip: second_user.zip, status: "packaged")
order_2.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 2)
order_2.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
order_2.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 32)

order_3 = third_user.orders.create!(name: third_user.name, address: third_user.address, city: third_user.city, state: third_user.state, zip: third_user.zip, status: "shipped")
order_3.item_orders.create!(status: "fulfilled", item: tire, price: tire.price, quantity: 6)
order_3.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 1)

order_4 = fourth_user.orders.create!(name: fourth_user.name, address: fourth_user.address, city: fourth_user.city, state: fourth_user.state, zip: fourth_user.zip, status: "cancelled")
order_4.item_orders.create!(status: "fulfilled", item: paper, price: paper.price, quantity: 1)
order_4.item_orders.create!(status: "fulfilled", item: pencil, price: pencil.price, quantity: 40)
