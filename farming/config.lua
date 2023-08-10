showZone = true;
zoneR, zoneG, zoneB, zoneA = 1, 255, 255, 40;



options = {

    dbTable = "_farm",
    pricePerSquare = 50,
    sellRate = 0.8, -- orginalPrice * sellRate

    corners = {
        show = true,
        propModel = `prop_gate_farm_post`,
    },

    growth = {
        -- true = plants die if water gets to zero, 
        -- false = plants keeps growing no matter what
        canDie = false,

        --How long it takes to water plant (ms)
        wateringtime = 3000,
        plantingTime = 3000,
    },

    keys = {

        help = {
            index = 167,
            name = "~INPUT_SELECT_CHARACTER_FRANKLIN~",
        },

        --Field
        plant = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },
        stopPlant = {
            index = 194,
            name = "~INPUT_FRONTEND_RRIGHT~"
        },
        inspect = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },
        stopInspect = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },
        showAuth = {
            index = 168,
            name = "~INPUT_SELECT_CHARACTER_TREVOR~"
        },
        showArea = {
            index = 19,
            name = "~INPUT_CHARACTER_WHEEL~"
        },
        waterPlant = {
            index = 215,
            name = "~INPUT_FRONTEND_ENDSCREEN_ACCEPT~"
        },
        pickUpPlant = {
            index = 194,
            name = "~INPUT_FRONTEND_RRIGHT~"
        },



        
        --Field shop
        buyButton = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },

        nextButton = {
            index = 175,
            name = "~INPUT_CELLPHONE_RIGHT~"
        },
        lastButton = {
            index = 174,
            name = "~INPUT_CELLPHONE_LEFT~"
        },

        sellButton = {
            index = 215,
            name = "~INPUT_FRONTEND_ENDSCREEN_ACCEPT~"
        },

        confirmSell = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },

        cancellSell = {
            index = 194,
            name = "~INPUT_FRONTEND_RRIGHT~"
        },



        -- Creator
        newCorner = {
            index = 38,
            name = "~INPUT_PICKUP~"
        },

        removeCorner = {
            index = 80,
            name = "~INPUT_VEH_CIN_CAM~"
        },

        saveZone = {
            index = 215,
            name = "~INPUT_FRONTEND_ENDSCREEN_ACCEPT~"
        },

        stopCreating = {
            index = 194,
            name = "~INPUT_FRONTEND_RRIGHT~"
        },

        moveClosestCorner = {
            index = 192,
            name = "~INPUT_FRONTEND_RUP~"
        },

        addId = {
            index = 52,
            name = "~INPUT_CONTEXT_SECONDARY~" 
        }
        --

    }   
}






cmd = {
    AuthorizePlayer = "AuthorizePlayer",
    RemovePlayer = "RemovePlayer",
    ChangeOwner = "ChangeOwner",
}


locations = {
    ["buy"] = {
        coords = vec3(2030.13, 4980.177, 41.1),
        name = "Field seller 🥕",
        blip = 375,
        color = 21
    },
    ["sell"] = {
        coords = vec3(863.2, 2173.0, 51.28),
        name = "Wholesale 🥕",
        blip = 374,
        color = 2
    }
}



