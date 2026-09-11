var _enemyCount = instance_number(obj_timeaffected)
var _instance
var _time = min(0.1,waitTime)

for(var _i = array_length(buffList.turnTerminated); _i > 0; _i--) //decrement TTE
{
	buffList.turnTerminated[_i-1].duration -= _time
	if(buffList.turnTerminated[_i-1].duration<=0)
	{
		buffList.turnTerminated[_i-1].expireFunc()
		
		delete buffList.turnTerminated[_i-1]
		array_delete(buffList.turnTerminated,_i-1,1)
		
		calcEffectiveStats()
	}
}

for (var _i = 0; _i < _enemyCount; _i++)
{
	_instance = instance_find(obj_timeaffected,_i)
	_instance.actionTimer -= _time
	if(_instance.actionTimer <= 0)
	{
		if (_instance.asleep) //wakey func
		{
			var _playerDist = tileDistObj(_instance,self)
			if(!inFog(_instance.x,_instance.y) && _playerDist<4)
			{				
				if(floor(random(3/effectiveStats.stealth))=0) 
				{
					_instance.asleep = false
					soundRand(sndBiterHerald)
				}
			}	
			_instance.actionTimer = 1
		}
		else
		{
			with(_instance) event_user(0)
			
			alarm[0] = global.gameDelay
			break;
		}	
	}
}
if(waitTime>0 && alarm[0] = 0)
{
	waitTime -= _time
	alarmRecursions--;
	
	if(alarmRecursions>1) event_perform(ev_alarm,0)
	else 
	{
		alarm[0] = 1
		alarmRecursions = 30
	}
}