seed = {
    ["cucumber_seed"] = {
        label = "Cucumber seed",
        phases = {
            `prop_cucumber1`,
            `prop_cucumber2`,
            `prop_cucumber3`,
            `prop_cucumber4`
        },
        product = "cucumber",
        maxAmount = 6, -- amount of products you can get harvesting
        dryingTime = 18, --hours
        growTime = 24, -- hours
        offset = -0.22
    },
    ["chili_seed"] = {
        label = "Chili seed",
        phases = {
            `prop_chili1`,
            `prop_chili2`,
            `prop_chili3`,
            `prop_chili4`
        },
        product = "chili",
        maxAmount = 6,
        dryingTime = 18, --hours
        growTime = 24, -- hours
        offset = -0.05
    },
    ["corn_seed"] = {
        label = "Corn seed",
        phases = {
            `prop_corn1`,
            `prop_corn2`,
            `prop_corn3`,
            `prop_corn4`
        },
        product = "corn",
        maxAmount = 6,
        dryingTime = 18, --hours
        growTime = 24, -- hours
        offset = -1.0
    },

    ["weed_seed"] = {
        label = "Weed seed",
        phases = {
            `prop_weed_02`,
            `prop_weed_02`,
            `prop_weed_01`,
            `prop_weed_01`
        },
        product = "weed",
        maxAmount = 6,
        dryingTime = 18, --hours
        growTime = 24, -- hours
        offset = 0.0
    }
}


-- Price of product when selling to wholesale
products = {
    ["cucumber"] = 4,
    ["chili"] = 4,
    ["weed"] = 4,
    ["corn"] = 4,
} 