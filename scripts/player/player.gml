function getWeaponDelay()
{
	
}

function getWeightToNext(_size)
{
	return((_size+1)*50)
}

function getMaxhp(_size)
{
	return(50+_size*25)
}

function textPopup(ix,iy,text) {

	var obj = instance_create_layer(ix,iy,layer,oPopupText);
	obj.txt = scribble("[fa_center][scale,1.5]"+text);
	return(obj)
}
