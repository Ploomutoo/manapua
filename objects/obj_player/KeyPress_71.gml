var _item = instance_place(x,y,obj_item)

if(_item!=noone)
{
	var _i = 0
	while(inventory[_i]!=-1)
	{
		_i++
		if(_i>=invSize) 
		{ //inventory full :(
			exit;	
		}
	}
	inventory[_i] = _item.item
	instance_destroy(_item)	
}