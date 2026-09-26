function saltFood(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{
			case "Fresh":
			case "Stale":
			case "Frozen":
			case "Deep Frozen":
			inventory[_index].condition = "Salted"
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndSalt)
			return(true)
		
			default:
			return(false)
		}
	}
}