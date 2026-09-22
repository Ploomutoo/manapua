function hookOther(_target) //spell version of pullother
{	
	
	if(tileDistObj(caster,_target)<2) exit;
	
	var _validPlaces = findEmptyAdjacent(caster)
	if(array_length(_validPlaces)>0)
	{
		var _i = irandom(array_length(_validPlaces)-1)
		
		_target.x = _validPlaces[_i][0]
		_target.y = _validPlaces[_i][1]
		
		soundRand(sndPull)
	}
}