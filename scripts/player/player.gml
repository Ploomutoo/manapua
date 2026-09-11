function getWeightToNext(_size)
{
	return((_size+1)*50)
}

function textPopup(ix,iy,text) {

	var obj = instance_create_layer(ix,iy,"Instances",oPopupText);
	obj.txt = scribble("[fa_center][scale,1.5]"+text);
	return(obj)
}

function defog(_tx,_ty)
{
	if(!layer_exists("ts_fog")) exit;
	checkFog(_tx,_ty)
	
	if(checkFog(_tx,_ty-1)) checkFog(_tx,_ty-2) //up
	if(checkFog(_tx,_ty+1)) checkFog(_tx,_ty+2) //down
	
	if(checkFog(_tx+1,_ty)) checkFog(_tx+2,_ty) //right
	if(checkFog(_tx-1,_ty)) checkFog(_tx-2,_ty) //left
	
	if(checkFog(_tx-1,_ty-1)) //up-left
	{ 
		checkFog(_tx-1,_ty-2) 
		checkFog(_tx-2,_ty-2) 
		checkFog(_tx-2,_ty-1) 
	}
	
	if(checkFog(_tx+1,_ty-1)) //up-right
	{ 
		checkFog(_tx+1,_ty-2) 
		checkFog(_tx+2,_ty-2) 
		checkFog(_tx+2,_ty-1) 
	}
	
	if(checkFog(_tx-1,_ty+1)) //down-left
	{ 
		checkFog(_tx-1,_ty+2) 
		checkFog(_tx-2,_ty+2) 
		checkFog(_tx-2,_ty+1) 
	}
	
	if(checkFog(_tx+1,_ty+1)) //down-right
	{ 
		checkFog(_tx+1,_ty+2) 
		checkFog(_tx+2,_ty+2) 
		checkFog(_tx+2,_ty+1) 
	}
	
}
function checkFog(_tx,_ty)
{
	if(_tx<0 || _tx >= global.mapSize[0] || _ty<0 || _ty >= global.mapSize[1]) return(false)
	
	tilemap_set(global.fog,0,_tx,_ty)
	return(!tilemap_get(global.walls,_tx,_ty))
}

function comparisonText(_1,_2)
{
	if(_1 = _2)
	{
		return(string(_1)+"\n")
	}
	else
	{
		return(string(_1)+"[c_orange]("+string(_2)+")\n")
	}
}