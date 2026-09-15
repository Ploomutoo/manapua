if(drawX!=x)
{
	drawX += (x-drawX)/5	
}
if(drawY!=y)
{
	drawY += (y-drawY)/5	
}

meterAmt += (sprite_get_number(spr_attackMeter) * actionTimer/lastActionDuration - meterAmt)/6