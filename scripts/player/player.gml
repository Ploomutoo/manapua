function textPopup(ix,iy,text) {

	var obj = instance_create_layer(ix,iy,layer,oPopupText);
	obj.txt = scribble("[fa_center][scale,1.5]"+text);
	return(obj)
}

function minCycle(add){
	
	soundRand(sndUiClick);
	
	var minStart = minion_selected;
	var minCount = array_length(minion_arr)-1;
	
	minion_selected+=sign(add);
	
	if(minion_selected<0) minion_selected = minCount;
	else if(minion_selected>minCount) minion_selected = 0;
}

function minion_sort (_elm1, _elm2)
{
	var sort_type = real(_elm1.object_index) - real(_elm2.object_index);
	var sort_deployed = (_elm1.state != st.carry) - (_elm2.state != st.carry);
	var sortId = real(_elm1) - real(_elm2);
    return sort_type*100 + sort_deployed*10 + sortId;
}

function minion_type_cycle(_add)
{
	repeat(abs(_add))
	{
		var start_type = minion_arr[minion_selected].object_index;
		var start_id = minion_arr[minion_selected].id;
		do
		{
			minion_selected += sign(_add);
			if(minion_selected < 0)
			{
				
			}
		}
		until(minion_arr[minion_selected].object_index != start_type || minion_arr[minion_selected].id = start_id)
	}
}
