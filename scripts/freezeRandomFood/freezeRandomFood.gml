function freezeRandomFood(_amt)
{
	repeat(_amt)
	{
		var _index = getRandomFoodInd()
		if(_index = -1) return(false)
		freezeFood(_index,0)
	}
}

function getRandomFoodInd()
{
	var _in = getFoodIndices()
	if(array_length(_in)<1) return(-1)
	else
	{
		return( _in[irandom(array_length(_in)-1)] )	
	}
}

function getFoodIndices()
{
	var _out = []
	for(var _i = 0; _i < array_length(global.player.inventory); _i++)
	{
		if(global.player.inventory[_i] != -1 && global.player.inventory[_i].slot = "Consumable")
		{
			array_push(_out,_i)
		}
	}
	return(_out)
}