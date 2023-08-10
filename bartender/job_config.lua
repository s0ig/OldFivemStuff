-- If you create new job remember to add needed stuff to 
-- addon_account, addon_inventory and datastore

whitelistedJobs = {
    ["bandits"] = {
        societyName = "society_bandits",
        positions = {
            alcohol = vec3(1981.6, 3053.0, 47.5), -- Alcohol storage

            bar1 = vec3(1984.49, 3054.7, 47.5),
            -- if you want to add multiple positions where players can offer drinks you can add them like this
            -- bar2 = vec3..
            -- bar3 = vec3..

            --if you have other script handling vehiclespawn, storages and bossactions then... you dont need to add these
            storage = vec3(1993.853, 3064.525, 47.04),
            boss = vec3(1983.31, 3066.7, 46.98),
            vehicles = vec3(1988.736, 3061.655, 47.2),
        },
        --These vehicles can be spawned from positions.vehicles
        vehicles = {
            {   label = "Burrito",    model = "burrito3"  },
            {   label = "Blista",     model = "blista"    },
        },
    },
}

