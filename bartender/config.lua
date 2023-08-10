maxBoxesInVehicle = 15;

positions = {
    vec3(-1484.0, -375.3, 40.16),
    vec3(1130.8, -983.3, 46.3),
    vec3(-1219.4, -910.7, 12.3),
    vec3(-2962.9, 391.3, 15.0),
    vec3(1165.659, 2714.385, 38.15),
    vec3(1389.3, 3607.7, 34.9)
}

keys = {
	["E"] = {
		index = 38,
		name = "~INPUT_PICKUP~"
	},
	["ENTER"] = {
		index = 191,
		name = "~INPUT_FRONTEND_RDOWN~"
	},
	["BACKSPACE"] = {
		index = 194,
		name = "~INPUT_FRONTEND_RRIGHT~"
	},
	["AUP"] = {
		index = 172,
		name = "~INPUT_CELLPHONE_UP~"
	},
	["ADOWN"] = {
		index = 173,
		name = "~INPUT_CELLPHONE_DOWN~"
	},
	["ARIGHT"] = {
		index = 175,
		name = "~INPUT_CELLPHONE_RIGHT~"
	},
	["ALEFT"] = {
		index = 174,
		name = "~INPUT_CELLPHONE_LEFT~"
	},
	["Z"] = {
		index = 48,
		name = "~INPUT_HUD_SPECIAL~"
	},
	["1"] = {
		index = 157,
		name = "~INPUT_SELECT_WEAPON_UNARMED~"
	},
	["2"] = {
		index = 158,
		name = "~INPUT_SELECT_WEAPON_MELEE~"
	},
	["3"] = {
		index = 160,
		name = "~INPUT_SELECT_WEAPON_SHOTGUN~"
	},
	["4"] = {
		index = 164,
		name = "~INPUT_SELECT_WEAPON_HEAVY~"
	},
	["5"] = {
		index = 165,
		name = "~INPUT_SELECT_WEAPON_SPECIAL~"
	},
	["6"] = {
		index = 159,
		name = "~INPUT_SELECT_WEAPON_HANDGUN~"
	},
	["7"] = {
		index = 161,
		name = "~INPUT_SELECT_WEAPON_SMG~"
	},
	["8"] = {
		index = 162,
		name = "~INPUT_SELECT_WEAPON_AUTO_RIFLE~"
	},
	["9"] = {
		index = 163,
		name = "~INPUT_SELECT_WEAPON_SNIPER~"
	},

}

translations = {
	["trunkisfull"] = "The trunk is full ",
	["sendinvoice"] = "Invoice",
	["setprice"] = "The invoice amount ",
	["setmessage"]  = "Invoice message ",
	["money"] = "€",
	["getstorage"] = "Update storage data",
	["notenoughmoney"] = "Not enough money",
	["rum"] = "Rum",
	["brandy"] = "Brandy",
	["whiskey"] = "Whiskey",
	["tequila"] = "Tequila",
	["vodka"] = "Vodka",
	["Beer1"] = "Cerveza Barracho",
	["Beer2"] = "Pißwasser",
	["Beer3"] = "A.M. Beer",
	["Beer4"] = "Stronzo",
	["Beer5"] = "Jakey's Lager",
	["Beer6"] = "Logger Beer",
	["cola"] = "Coca-cola",
	["jaffa"] = "Jaffa",
	["take"] = "Take",
	["putaway"] = "Put away",
	["givedrink"] = "Offer a drink",
	["removedrink"] = "Remove the drink",
	["swig"] = "Swig",
	["bottomsup"] = "Bottoms up",
	["takedrink"] = "Take a drink",
	["outofstock"] = "Out of stock",
	["removevehicle"] = "Remove vehicle",
	["destroy"] = "Destroy box",
	["putbox"] = "Store box",
	["nextplayer"] = "Next",
	["prevplayer"] = "Prev",
	["writeinvoice"] = "Write invoice",
	["emptystorage"] = "Storage is empty",
	["cancel"] = "Cancel"
 }

alcoholStr = { -- If you use any alcohol effect scripts here you can change values how much to add effect when player drinks beer
 	-- See event alcoholEffect in client_editable.lua
	["rum"] = 32,
	["brandy"] = 34,
	["whiskey"] = 36,
	["tequila"] = 38,
	["vodka"] = 40,
	["Beer1"] = 5,
	["Beer2"] = 6,
	["Beer3"] = 7,
	["Beer4"] = 8,
	["Beer5"] = 9,
	["Beer6"] = 10,
	["cola"] = 0,
	["jaffa"] = 0,
}

prices = { -- Price per drink when purchased from liquor store
	["rum"] = 3,
	["brandy"] = 3,
	["whiskey"] = 4,
	["tequila"] = 4,
	["vodka"] = 4,
	["Beer1"] = 3,
	["Beer2"] = 3,
	["Beer3"] = 4,
	["Beer4"] = 4,
	["Beer5"] = 4,
	["Beer6"] = 4,
	["cola"] = 1,
	["jaffa"] = 1,
}

bottlesInBox = { -- how many drinks in box
	["rum"] = 100,
	["brandy"] = 100,
	["whiskey"] = 100,
	["tequila"] = 100,
	["vodka"] = 100,
	["Beer1"] = 24,
	["Beer2"] = 24,
	["Beer3"] = 24,
	["Beer4"] = 24,
	["Beer5"] = 24,
	["Beer6"] = 24,
	["cola"] = 24,
	["jaffa"] = 24,
}


