//position
z = 0;
hide = false;
mousedOver = false;

item = new Item()
item.name = "Flesh"
item.consumable = true
item.slot = "Consumable"
item.healing = 10
item.weightgain = 10

item.funcUse = eatFood
item.tooltip = generateTooltip(item)