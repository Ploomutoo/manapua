lastActionDuration = 0
switch(effectiveStats.behavior)
{
	case "Confused":
		confused();
		break;
		
	default:
		normal();
		break;
}

//decayBuff("turnTerminated",lastActionDuration)