var _enemyCount = instance_number(obj_timeaffected)
var _instance
var _time = min(0.1,waitTime)
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
				if(irandom(3)=0) 
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
			alarm[0] = 10
			break;
		}	
	}
}
if(waitTime>0 && alarm[0] = 0)
{
	waitTime -= _time
	alarmRecursions--;
	
	if(alarmRecursions>1) event_perform(ev_alarm,0)
	else alarm[0] = 1
}