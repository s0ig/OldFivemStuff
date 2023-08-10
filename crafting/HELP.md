----------------------------------------
**If you use ESX dont mind about this..**
You need to have items table in your DB to make this script work
And it should include atleast these columns
- name, label, rare - 
----------------------------------------


**1.0** 

	- crafting_formulas -
	
	category - You can choose what every you want (Weapons, Ammo, Food, asdasd, Book, apsklda..)

	formula - false OR formula_name (if formula_name then read 1.2)

	materials - example [{"name":"meat", "amount":1 },{"name":"stick", "amount":1, "remove":false}]
				by adding "remove":"false" this item will not be deleted while crafting

	product - end result item

	amount - Amount how many products you will get

	time - How long it takes to craft product

	reqzone - true or false (if true then read 1.1)

	reqjob - you can "whitelist" formulas only for some job [ only for 1 job atm ]

	type - item or weapon

	https://i.imgur.com/6WZzqnv.png

**1.1**
	
	- crafting_zones -

	categorys - So here we add categories that we used when creating formulas - ["Weapons,"Other","asdasd"...]

	Now we have 2 options

		We can use 

			coords - {"x":2047.04,"y":3927.54,"z":32.2} <-- If player's are close this point. They can craft items from your chosen category.
		or 
			objects - {"prop_beach_fire"} <-- If player's are close this prop. They can craft items from your chosen category.


	https://i.imgur.com/7Q0Z2CU.png

**1.2**
	
	- crafting_formulas_players -

	if you create an formula that requires "formula". You need to make usable items so player's can get those formulas.
	You can add this stuff in server/usable_items.lua

	---
	When you add new formula items to your db. You need to choose rarity for them
	from 1-5. 

	Using this item will roll from those created formulas and give 1 of them for you.

	https://thumbs.gfycat.com/SpectacularHonoredDiamondbackrattlesnake-mobile.mp4
	
	ESX.RegisterUsableItem('formula_tube', function(source)
 		rollForFormula(source)
	end)
	---

	ESX.RegisterUsableItem('formula_steak', function(source)
		local xPlayer = ESX.GetPlayerFromId(_source)
		xPlayer.removeInventoryItem(name, 1)
		TriggerEvent("sm_crafting:newFormula", source, 'formula_steak')
	end)


**1.3**

	- Images - 
	drop your images to ui/img/items name them same as your item "hash" name is.
	If you use some version of inventoryhud you can easily just copy images from there
	to this script.

**1.4 Here is an example how you could do things..**
	
	1. Create new formula to crafting_formulas
		https://i.imgur.com/6WZzqnv.png || db crafting_formulas

	2. If you choose it to reqzone then
	   Use coords https://i.imgur.com/bbtyNxq.png || db crafting_zones
	   or
	   Use props https://i.imgur.com/8uUrBaM.png || db crafting_zones

	3. If you choose that it needs to use "formula"

	   https://i.imgur.com/1m6u2KK.png || db crafting_formulas
	   then
	   Remember to add rarity to "rare" from 1-5 
	   https://i.imgur.com/02W0VEP.png || db items
	   then
	   Create usable item to server/usable_itens.lua

		ESX.RegisterUsableItem('formula_metaltube', function(source)
			local xPlayer = ESX.GetPlayerFromId(_source)
			xPlayer.removeInventoryItem(name, 1)
			TriggerEvent("sm_crafting:newFormula", source, 'formula_steak')
		end)

	4. Add needed images to ui/img/items

	5. And voila you are done.


       




