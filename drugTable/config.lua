drugs = {
    ["gamma"] = {

        cookingTime = 0.1, -- min

        label = "Gamma",

        requiredItems = {
            table = {
                name = "table_1",
                model = `v_ret_ml_tablea`,
                amount = 1,
            },
            otherItems = {
                {
                    name = "gazbottle",
                    label = "Kaasupullo",
                    amount = 1,
                },
            }
        },


        recipe = {
            {
                label = "Vesi",
                name = "water",
                amount = 5,
            },
        
            {
                label = "Lakka",
                name = "lakka",
                amount = 3,
            },
        
            {
                label = "Lipeä",
                name = "lipea",
                amount = 2,
            },
        
            {
                label = "Ruokasooda",
                name = "rsooda",
                amount = 3,
            },
        },
        
        otherIngredients = {
            {
                label = "Vesi",
                name = "water",
                effects = "water",
                amount = 10,
            },
            {
                label = "Natriumhydroksidi",
                name = "naoh",
                effects = "ph",
                amount = -1,
            },
        
            {
                label = "Kaliumhydroksidi",
                name = "koh",
                effects = "ph",
                amount = 1,
            },
        
            {
                label = "Sitruunahappo",
                name = "shappo",
                effects = "ph",
                amount = -1,
            },
        
        }
    }
}