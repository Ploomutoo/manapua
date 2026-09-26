function skewerFood(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{
			case "Frozen":
			case "Deep Frozen":
			case "Skewered":
			case "Rotten":
			return(false)
			
			default:
			inventory[_index].condition = "Skewered"
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndStab)
			return(true)
		}
	}
}