//position
z = 0;
hide = false;
mousedOver = false

item = new Item()
item.name = "Flesh"
item.slot = "Food"
item.consumable = true
item.foodval = 5

item.funcUse = eatFood

item.tooltip = generateTooltip(item)