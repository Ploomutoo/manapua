function grillFood(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{			
			case "Deep Frozen":
			inventory[_index].condition = "Frozen"
			break;
			
			case "Frozen":
			inventory[_index].condition = "Thawed"
			break;
			
			case "Grilled":
			inventory[_index].condition = "Burnt"
			break;
			
			case "Burnt":
			inventory[_index] = -1
			inventory[_index].healing		= 0
			inventory[_index].specialAmt[0]	= 0
			break;
			
			default:
			inventory[_index].condition = "Grilled"
			inventory[_index].healing		= ceil(inventory[_index].healing*1.5)
			inventory[_index].specialAmt[0]	= ceil(inventory[_index].specialAmt[0]*1.5)
			break;
		}
		inventory[_index].tooltip = generateTooltip(inventory[_index])
		soundRand(sndFireHiss)
		return(true)
	}
	show_debug_message("Could not run grilling code for some reason")
	return(false)
}