function clock(_time){
	with(obj_timeaffected) 
	{
		if (asleep) 
		{
			var _playerDist = tileDistObj(self,target)
			if(!inFog(x,y) && _playerDist<4)
			{				
				if(irandom(3)=0) 
				{
					asleep = false
					soundRand(sndBiterHerald)
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

function inFog(_x,_y)
{
	//if(_x<0 || _x >= global.mapSize[0] || _y<0 || _y >= global.mapSize[1]) return(true)
	
	return(tilemap_get(global.fog,floor(_x/64),floor(_y/64)))
}