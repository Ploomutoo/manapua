if(event_data[? "string"]="sndWeightup") 
{
	//show_debug_message("obama")
	displaysize = queuesize
}

var sound = asset_get_index(event_data[? "string"])

if(sound != -1) soundRand(sound)