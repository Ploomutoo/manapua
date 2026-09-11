function dodgeToEvasion(_dodge)
{ //processes raw dodge value to percent evasion
	var _out = (_dodge*75)/(_dodge+15)
	return(_out)
}