Crud Functionality For Bulk Disounts

Final story 1

As a Merchant
When I visit my dashboard (/merchant/dashboard), I see a link to manage discounts
When I click this link, is see a link to create a new discount
I am taken to a form when I can enter my discount information
After my discounts are set, I see the discount terms on the (/merchant/:id/items)

Final story 2
As a merchant
When I visit my dashboard (/merchant/dashboard), I see a link to manage discounts
When I click this link, is see list of my current discounts
Next to each, I see a link to edit that discount
I am taken to a form when I can update/edit my discount terms
After my discounts are set, I see the discount terms on the (/merchant/:id/items)

As a Default User
After my discounts are set, I see the discount terms on the (/merchant/:id/items)
When a user adds enough value or quantity of a single item to their cart, the bulk discount will automatically show up on the cart page.
When there is a conflict between two discounts, the greater of the two will be applied.

Final discounted prices should appear on the orders show page.

bulk_discounts
merchant:refernces
minimum_item_quantity:integer
percent_discount:float