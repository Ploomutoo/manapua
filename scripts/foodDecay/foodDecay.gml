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
		case "Frozen":
		case "Salted":
		break;
		
		case "Fresh":
		inventory[_index].condition = "Stale"
		inventory[_index].healing = min(inventory[_index].healing-10,0)
		break;
		
		case "Stale":
		inventory[_index].condition = "Rotten"
		break;
	}
	inventory[_index].tooltip = generateTooltip(inventory[_index])
}