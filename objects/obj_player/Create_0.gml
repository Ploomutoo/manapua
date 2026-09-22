event_inherited()
//resources

//counters and tracking
iFrames = 0;
drawX = x
drawY = y
inputBuffer = -1

inventory = []
invSize = 15
for(var i = 0; i < invSize; i++)
{
	inventory[i] = -1	
}

weight =	0
weightclass  = 0
weightToNext = getWeightToNext(weightclass)
armorDisparity = 0
weaponDisparity = 0
preciseDisparity = 0

baseStats = //all stats
{
	//food modifiable
	max_hp : 100,
	
	dmgMod : 100,
	defense : 3,
	dodge : 1,
	lifesteal : 0,
	intelligence : 1,
	thorns : 0,
	critChance : 10,
	critDamage : 100,
	
	rFire : 0,
	rIce  : 0,
	rDark : 0,
	rPois : 0,
	rElec : 0,
	
	//item modifiable
	reach : 1,
	multistrike : 1,
	riposte : 0,
	flight : false,
	foodheal : 1,
	stealth : 1,
	
	wepDamage : 10,
	wepDelay : 1,
	moveDelay : 1,
	
	viewRadius : 3,
	incomingDamage : 1, //Used by Divinity
	spellCooldown : 1, //Used by Mana Frenzy
	speedAll : 1, //Used by Haste
	
	//functionss
	onKill : [],
	onStrike : [],
	onSeeDeath : [],
	onHit : ["playerTakeDamage:addParam"],
	onDeath : [],
	
	library : ["Blink","Meathook","Meteor-Storm","Mega-Meteor-Storm","Minigun"]
}

effectiveStats = baseStats 
//stats after being modified by buffs and armor
//what is actually checked

hp = baseStats.max_hp
waitTime = 0
evasion = dodgeToEvasion(effectiveStats.dodge)
finalDelay = 1

buffList = 
{
	healingTerminated : [],
	damageOverTime : [],
	killTerminated : [],
	floorTerminated : [],
	turnTerminated : [new buff("Optimism","Feelin' fine",,10,"%max_hp",1.25)],
	attackTerminated : [],
	killTerminated : [],
	defendTerminated : [],
	damageTerminated : [],
	allBuffs : []
}

characterPane =
{
	open : false,
	x : 360+128,
	y : 128
}

//Spell!!! ------------------------------------------
libraryOn = 0
spellCasting = new Spell(baseStats.library[libraryOn])

global.player = self
global.fog = layer_tilemap_get_id("ts_fog")
layer_set_visible(layer_get_id("ts_fog"),1)
global.walls = layer_tilemap_get_id("ts_walls")
global.levelSeed = random_get_seed()
global.level = 0
global.cheat = parameter_count()==3&&string_count("GMS2TEMP",parameter_string(2))
global.enemyGenList = load_csv("enemies-test.csv")

enum gamespeed 
{
	slow,
	medium,
	fast,
	ultra
}
global.gameSpeed = gamespeed.medium
global.gameDelay = 10

switch(global.gameSpeed)
{
	case gamespeed.slow:	global.gameDelay = 15; break;
	case gamespeed.medium:	global.gameDelay = 10; break;
	case gamespeed.fast:	global.gameDelay = 5; break;
	case gamespeed.ultra:	global.gameDelay = 1; break;
}

defineParticles()