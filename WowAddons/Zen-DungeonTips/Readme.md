/dump C_Map.GetBestMapForUnit("player")

## AI Prompt

Use the provided lua data structure as an example. Convert the given csv data into the lua format, adhering to TANK/HEAL/Interrupt etc.
  
  --------------------
    -- GRIM BATOL   ----
    --------------------
    [224152] = {
        { "TANK",      "Brutal Strike: Tank targeted phys hit" },
    }, -- Twilight Brute
    
    [224219] = {
        { "Interrupts", "Mass Tremor: 60yd AoE nature hit and 30% slow for 10s" }
    }, -- Twilight Earthcaller

    [224609] = {
        { "Important", "Umbral Wind: 100yd AoE shadow hit and knock back, can LoS" }
    }, -- Twilight Destroyer

    [224221] = {
        { "TANK",      "Rive: Tank targeted phys hit that applies a stacking 10% phys damage taken increase for 12s" },
        { "Important", "Reckless Tactic: Enrages all mobs within 100yds, clearing any active CC, increasing damage done by 20%, and damage taken by 10% for 10s" }
    }, -- Twilight Overseer

    [40167] = {
        { "Interrupts", "Sear Mind: Random target shadowflame channel and stun for 5s" }
    }, -- Twilight Beguiler

    [40166] = {
        { "Important", "Beguile: 20% damage taken increase and stun for 15s, happens near pull" },
    }, -- Molten Giant

    [224240] = {
        { "Important", "Blazing Shadowflame: Random target line attack (does not follow)" },
        { "TANK",      "Shadowflame Slash: Tank targeted shadowflame hit and stacking 8s DoT" }
    }, -- Twilight Flamerender
    
    [224249] = {
        { "Important", "Ascension: 8yd AoE shadowflame hit that transforms the mob, causing ticking shadowflame damage to the party every 2s until dead" }
    }, -- Twilight Lavabender

    [224271] = {
        { "Interrupts", "Shadowflame Bolt: Random target shadowflame hit" },
    }, -- Twilight Warlock

    [224853] = {
        { "Important", "Shadow Wound: On death debuffs players within 100yds with a stacking 5% shadow damage taken increase for 15s" }
    }, -- Mutated Hatchling

    [39392] = {
        { "Important", "Mind Piercer: Multiple 4yd swirlies that charm players hit for 10s" },
    }, -- Faceless Corruptor
