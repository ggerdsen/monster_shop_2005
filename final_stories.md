Crud Functionality For Bulk Disounts

Final story 1 [x]

As a Merchant
When I visit my dashboard (/merchant/dashboard), I see a link to manage discounts
When I click this link, is see a link to create a new discount
I am taken to a form when I can enter my discount information
After my discounts are set, I see the discount terms on the (/merchant/:id/items)

Final story 2 [x]
As a merchant
When I visit my dashboard (/merchant/dashboard), I see a link to manage discounts
When I click this link, is see list of my current discounts
Next to each, I see a link to edit that discount
I am taken to a form when I can update/edit my discount terms
After my discounts are set, I see the discount terms on the (/merchant/:id/items)

Final story 3 [x]
As a merchant
When I visit my dashboard (/merchant/dashboard), I see a link to manage discounts
When I click this link, is see list of my current discounts
Next to each, I see a link to delete that discount
After clicking, my discount is destroyed
After deleting, I no long see this discounts' terms on the (/merchant/:id/items)

Final story 4 [x]
As a customer
After discounts are set, I see the discount terms on the (/merchant/:id/items)
When I add enough of a single item to their cart, the bulk discount will automatically show up on the cart show page.
The name of the discount(s) is show in the subtotal column along with the adjusted price(s)
The total reflects the discounts applied in the subtotal column

As a Default User

When there is a conflict between two discounts, the greater of the two will be applied.

Final story 5

Final discounted prices should appear on the orders show page.

bulk_discounts
merchant:refernces
minimum_item_quantity:integer
percent_discount:float