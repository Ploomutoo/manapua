var _topCorner = [invCorner[0]-360,invCorner[1]]

if(point_in_rectangle(mouse_x,mouse_y,_topCorner[0],_topCorner[1],
_topCorner[0]+invSize[0]*64,_topCorner[1]+invSize[1]*64))
{
	var cursOn = []
	cursOn[0]  = floor((mouse_x-_topCorner[0])/64)
	cursOn[1]  = floor((mouse_y-_topCorner[1])/64)
	
	invOn = cursOn[0] + cursOn[1]*5
	if(invOn >= global.player.invSize) invOn = -1
}
else
{
	invOn = -1	
}

if(mouse_check_button_pressed(mb_left) && invOn != -1)
{
	if(global.player.inventory[invOn]!=-1)
	{
		holding = global.player.inventory[invOn]
		holdingPrev = invOn
		global.player.inventory[invOn] = -1
	}
}

if(mouse_check_button_released(mb_left) && holding != -1)
{
	if(invOn = -1)
	{
		var _hitbox = [-320,146,-81,317] //body hitbox
		if(holding.slot = "Consumable" || holding.slot = "Potion") _hitbox = [-280,60,-100,180] //mouth hitbox
		
		if(point_in_rectangle(mouse_x,mouse_y,_hitbox[0],_hitbox[1],_hitbox[2],_hitbox[3]))
		{
			with(global.player)
			{
				if(other.holding.slot != "") //unequip items in the same slot
				{
					for(var _i = 0; _i<invSize; _i++)
					{
						if(inventory[_i] != -1 && inventory[_i].equipped && inventory[_i].slot = other.holding.slot)
						{
							inventory[_i].funcUse()
						}
					}
				}
				
				other.holding.funcUse()
				if(other.holding.slot != "Consumable" && other.holding.slot != "Potion") inventory[other.holdingPrev]=other.holding
				
				calcEffectiveStats()
			}
			
		}
		else if (mouse_x>0) //Throw away!
		{
			if(holding.equipped) holding.funcUse()
			
			var _itemObj = instance_create_layer(global.player.x,global.player.y,layer,obj_item_empty)
			_itemObj.item = holding
		}
		else
		{
			global.player.inventory[holdingPrev] = holding
		}
	}
	else
	{
		if(global.player.inventory[invOn]=-1) //no item in slot
		{
			global.player.inventory[invOn] = holding
		}
		else //slot already occupied
		{
			global.player.inventory[holdingPrev] = global.player.inventory[invOn]
			global.player.inventory[invOn] = holding
		}
	}
	holding = -1
	holdingPrev = -1
}