function clock(_time){
	with(obj_timeaffected) 
	{
		if (asleep) 
		{
			var _playerDist = tileDistObj(self,target)
			if(_playerDist<4)
			{				
				if(irandom(3)=0) 
				{
					asleep = false
				}
				else
				{
					//soundRand(sndSnore)	
				}
			}	
			actionTimer = 1
			continue;
		}
		
		actionTimer -= _time
		while(actionTimer <= 0)
		{	
			event_user(0)
		}
	}
}

function tileDistObj(_o1,_o2)
{
	if(!instance_exists(_o1) || !instance_exists(_o2)) return(-1)
	
	var _out = abs(_o1.x - _o2.x)
	_out += abs(_o1.y - _o2.y)
	return(_out/64)
}