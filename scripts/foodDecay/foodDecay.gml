function foodDecayAll()
{
	//var _food = []
	for(var _i = 0; _i < array_length(inventory); _i++)
	{
		if(inventory[_i] != -1 && inventory[_i].slot = "Consumable")
		{
			//array_push(_food,_i)
			foodDecay(_i)
		}
	}
	
}

function foodDecay(_index)
{
	switch(inventory[_index].condition)
	{
		case "Salted":
		break;
		
		case "Deep Frozen":
		inventory[_index].condition = "Frozen"
		break;
		
		case "Frozen":
		inventory[_index].condition = "Thawed"
		break;		
		
		case "Fresh":
		inventory[_index].condition = "Stale"
		inventory[_index].healing = min(inventory[_index].healing,0)
		break;
		
		case "Stale":
		case "Thawed":
		case "Sweetened":
		case "Pepper":
		case "Skewered":
		inventory[_index].condition = "Rotten"
		inventory[_index].healing = min(inventory[_index].healing,-10)
		inventory[_index].specialAmt[0] = 0
		break;
		
		case "Rotten":
		inventory[_index] = -1
		break;
	}
	inventory[_index].tooltip = generateTooltip(inventory[_index])
}