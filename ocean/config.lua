Config = {}
Config.pressMessage = "Press [E] to loot"
Config.sonarOnMessage = "Sonar On"
Config.sonarOffMessage = "Sonar Off"
Config.treasureAmount = 5;
Config.objectsPerArea = 100;
Config.drawlight = 50.0; -- if player distance is smaller than this value, object will be "highlighted"

--[[
	Itempool tiers
	[1] 50.21%
	[2] 24.94%, 
	[3] 17.01%, 
	[4] 7.33%,
	[5] 0.51%, 
]]
Config.itempool = {
	treasure = {
		[1] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[2] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[3] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},	
		[4] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[5] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		}
	},

	trash = {
		[1] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[2] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[3] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},	
		[4] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		},
		[5] = {
			{name="item",		 			label="Some random item..",		type="item",	min=1,	max=5},
			{name="money",					label="Money",					type="money",	min=1,	max=1000},
			--{name="weapon_assaultrifle",	label="Pistol",					type="weapon",	min=1,	max=1},
		}
	}
}