-- This is the full database of tips.

local _, addon = ...;


-- Each array uses the format: {{"Type", "Tip1"}, {"Type", "Tip2"}}
-- Color code information for the different types of tips:
-- Important:	Green
-- Interrupt:	Orange
-- Healer Note: Light Blue
-- Blank:		Default Blizzard color
--local tipsColors = {
--    ["Legion"] = { 0.8, 0.8, 0.8 },
--    ["Important"] = { 1, 0.59, 0.14 },
--    ["Defensives"] = { 1, 0.57, 0.12 },
--    ["Interrupts"] = { 0.37, 0.92, 1 },
--    ["Dodge"] = { 0.54, 0.81, 0.94 },
--    ["PriorityTargets"] = { 1, 1, 0 },
--    ["Fluff"] = { 1, 1, 1 },
--    ["Advanced"] = { 0.75, 0.55, 0.35 },
--    ["Avoid"] = { 0.75, 0.55, 0.35 },
    
--    ["HEALER"] = { 0.2, 0.98, 0.25 },
--    ["TANK"] = { 0.8, 0.6, 0 },
--    ["DAMAGE"] = { 1, 0.72, 0.68 },

    
--    --["DEMONHUNTER"] = {0.64, 0.19, 0.79},
--    ["DEMONHUNTER"] = { 0.68, 0.22, 0.84 },
--    ["DRUID"] = { 1, 0.49, 0.04 },
--    ["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
--    ["HUNTER"] = { 0.67, 0.83, 0.45 },
--    ["MAGE"] = { 0.41, 0.8, 0.94 },
--    ["MONK"] = { 0, 1, 0.59 },
--    ["PALADIN"] = { 0.96, 0.55, 0.73 },
--    ["PRIEST"] = { 1, 1, 1 },
--    ["ROGUE"] = { 1, 0.96, 0.41 },
--    ["SHAMAN"] = { 0, 0.44, 0.87 },
--    ["WARRIOR"] = { 0.78, 0.61, 0.43 },
--    ["WARLOCK"] = { 0.58, 0.51, 0.79 }

--}
tipsMap = {
    -- Example
    [126389] = { { "Blank", "A+ Tip right here. \n It's a shame it's so damn long eh? It just goes on and on and on and ooon" },
        { "Interrupt", "INTERRUPT: Stone Bolt" } }, -- In this example case, all roles will see "A+ Tip right here" on the mobs tooltip but only Healers will see the second tip.

    --
    [99999] = { { "Important", "PlaceholderImportant" }, { "Important", "PlaceholderImportant" },
        { "Advanced",  "PlaceholderAdvanced" } }, -- Tirnenn Villager	
    [8903218] = { { "Important", "" } },

    --------------------
    -- NERUBAR RAID ----
    --------------------
    [215657] = {
        { "Important", "Stalkers webbing: Spreads webs which root. Webs can be removed with Digestive Acid aura on random players." },
        { "Important", "Carnivorous Contest: Soak, then pull against boss" },
        { "Important", "Phase 2: Avoid boss swoops, kill adds. After phase ends, feed boss the add guts" },
        { "TANK",      "Defensive before Brutal Crush" },
        { "TANK",      "Swap after Brutal Crush" },
        { "TANK",      "AMS allows Web Clearing" },
        { "TANK",      "P1: Tank between mid and edge facing out" },
        { "TANK",      "P1: Carnivorous Contest: Tanks help soak big circle, then run from suck" },      
        { "TANK",      "P2: Boss will come up opposite egg spawns at end phase. Let adds walk toward you" },        
        { "TANK",      "P2: 1 tank stay in melee, boss can swing during cast" },
        { "HEALER",    "CDs on Venomous Lash and Brutal Lashing soak" }
    }, -- Ulgrax

    [214502] = {
        { "Important", "Gruesome Disgorge: Raid alternates soaking this on top of add spawn pillar, sends everyone hit to shadow realm" },
        { "Important", "Shadow Realm: Kick Black Bulwark, tank Lost Watchers, kill adds before they reach boss" },
        { "Important", "Grasp From Beyond: Run out of raid" },
        { "Important", "Goresplatter: Get out of circle, large raidwide dot after" },
        { "HEALER",    "CDs on Crimson Rain heal absorb" },
        { "TANK",      "Aim Gruesome Disgorge at purple orbs (adds)" },
        { "TANK",      "Be ready to swap after active tank goes to shadow realm after Gruesome" },
        { "TANK",      "Tank Watcher + interrupt him, pull to stationary adds" },
        { "Important", "DPS: Horrors > Harbinger > Watcher" }
    }, -- Bloodbound Horror

    [214503] = {
        { "Important", "Phase Blades: 4 targeted players form a box around marker on edge of arena, rotate marker as fight goes on" },
        { "Important", "Decimate: 3 players targeted need to get between boss and one of the ghosts left by Phase Blades" },
        { "Important", "Shattering Sweep: Run out of circle" },
        { "TANK",      "Rotate sikran tanking around inner circle of room"},
        { "TANK",      "Boss does 3 hit combo, 2x expose then one phase lunge, MUST tank swap after 2nd expose and before phase lunge lands" },
        { "TANK",      "Run out of purple shattering sweep" },
        { "HEALER",    "CDs when clones explode" }
    }, -- Sikran

    ---
    [214504] = {
        { "Important", "Rolling Acid: Like dungeon, move it to the correct side" },
        { "Important", "Spinneret Strands: Targeted players move out of raid then pull web to break it" },
        { "Important", "Infested Spawn: Targeted players stack in melee" },
        { "Important", "Fly Away: Chase and interrupt Acidic Eruption" },
        { "TANK",      "Casts Savage Assault twice in a row, must tank swap immediately after each. Use defensives before initial hit" },
        { "TANK",      "Offtank pick up small adds until they fixate at 50%" },
        { "HEALER",    "CDs on Erosive Spray, watch heal aggro from adds" }
    }, -- Rash'anan

    [214506] = {
        { "Important", "Experimental Dosage: 2 targeted players hatch eggs closest to active puddle" },
        { "Important", "Big Egg: Spider that must be tanked" },
        { "Important", "Medium Eggs: Worm that must be kicked" },
        { "Important", "Cluster Eggs: Parasites fixate, CC them" },
        { "TANK",      "Swap after Volatile Concoction" },
        { "TANK",      "Move boss around eggs" },
        { "HEALER",    "CDs for boss full energy" },
        { "HEALER",    "Heal Tank to full before Volatile Concoction ends" }
    }, -- Broodtwister Ovinax

    [217748] = {
        { "Important", "Assassination: Targeted players run to hexagon corners" },
        { "Important", "Nether Rift: All enemies pull, should balance out if tank places boss on lighter side" },
        { "Important", "Twilight Massacre: Targeted players stand next to clones and force outwards" },
        { "Important", "QUEENSBANE: DoT that aoes on expiration, RUN OUT of raid" },
        { "Important", "Regicide: Line telegraphs on random targets" },
        { "TANK",      "Swap after Void Shredder, which does more damage as it goes on" },
        { "HEALER",    "Keep everyone above 10% hp or executed" },
        { "HEALER",    "Intermission has heavy raidwide damage" }
    }, -- Nexus Princess Kyveza

    ---
    [217489] = {
        { "Important", "Web Bombs: Assigned pairs trigger bombs for binding webs" },
        { "Important", "Reckless Charge: Put binding webs in path" },
        { "Important", "Shatter Existence: Avoid filling slices, go into first after explosion" },
        { "Important", "Web Vortex: Run out away from your web partner" },
        { "Important", "Stinging Swarm: 3 targeted players form triangle in center, dispel before Entropy finishes casting" },
        { "Important", "Spike Storm: Avoid rings" },
        { "TANK",      "Stack bosses during P1, must move Anub to Takazj" },
        { "TANK",      "Split bosses in P2 before stinging swarm" },
        { "HEALER",    "Plan Stinging Swarm dispels to bounce debuffs to boss, make sure final dispel is during Cataclysmic cast" }
    }, -- Anub'arash (Silken Court)
    [223779] = {
        { "Important", "Web Bombs: Assigned pairs trigger bombs for binding webs" },
        { "Important", "Reckless Charge: Put binding webs in path" },
        { "Important", "Shatter Existence: Avoid filling slices, go into first after explosion" },
        { "Important", "Web Vortex: Run out away from your web partner" },
        { "Important", "Stinging Swarm: 3 targeted players form triangle in center, dispel before Entropy finishes casting" },
        { "Important", "Spike Storm: Avoid rings" },
        { "TANK",      "Stack bosses during P1, must move Anub to Takazj" },
        { "TANK",      "Split bosses in P2 before stinging swarm" },
        { "HEALER",    "Plan Stinging Swarm dispels to bounce debuffs to boss, make sure final dispel is during Cataclysmic cast" }
    }, -- Anub'arash (Silken Court)

    [217491] = {
        { "Important", "Web Bombs: Assigned pairs trigger bombs for binding webs" },
        { "Important", "Reckless Charge: Put binding webs in path" },
        { "Important", "Shatter Existence: Avoid filling slices, go into first after explosion" },
        { "Important", "Web Vortex: Run out away from your web partner" },
        { "Important", "Stinging Swarm: 3 targeted players form triangle in center, dispel before Entropy finishes casting" },
        { "Important", "Spike Storm: Avoid rings" },
        { "TANK",      "Stack bosses during P1, must move Anub to Takazj" },
        { "TANK",      "Split bosses in P2 before stinging swarm" },
        { "HEALER",    "Plan Stinging Swarm dispels to bounce debuffs to boss, make sure final dispel is during Cataclysmic cast" }
    }, -- Takazj (Silken Court)

    [218370] = {
        --[219778] = {
        { "Important", "Reactive Toxin: Move behind boss" },
        { "Important", "Venom Nova: Group in outer circle of Froth from Reactive Toxin, pop center to hop over ring" },
        { "Important", "Silken Tomb: Loose spread around boss, kill roots" },
        { "Important", "Predation: Run from center" },
        { "Important", "Ascent: Split raid into two groups, voidspeaker death knockback to platforms" },
        { "Important", "Adds: Voidspeakers interrupt shadowblast. Burn devoted worshippers, others have knockbacks" },
        { "Important", "Abyssal Conduit: One targeted player place in center, other on the outside" },
        { "Important", "Summoned Acolytes: Kill ASAP, interrupt null detonation" },
        { "Important", "Frothing Gluttony: Use the abyssal conduits to teleport over the ring" },
        { "TANK",      "Drag boss around outside of arena" },
        { "TANK",      "Swap after Liquify" },
        { "TANK",      "Infest - run behind group" },
        { "HEALER",    "Regret your decision to play a healer" }
    }, -- Queen Ansurek
    [219778] = {
        { "Important", "Reactive Toxin: Move behind boss" },
        { "Important", "Venom Nova: Group in outer circle of Froth from Reactive Toxin, pop center to hop over ring" },
        { "Important", "Silken Tomb: Loose spread around boss, kill roots" },
        { "Important", "Predation: Run from center" },
        { "Important", "Ascent: Split raid into two groups, voidspeaker death knockback to platforms" },
        { "Important", "Adds: Voidspeakers interrupt shadowblast. Burn devoted worshippers, others have knockbacks" },
        { "Important", "Abyssal Conduit: One targeted player place in center, other on the outside" },
        { "Important", "Summoned Acolytes: Kill ASAP, interrupt null detonation" },
        { "Important", "Frothing Gluttony: Use the abyssal conduits to teleport over the ring" },
        { "TANK",      "Drag boss around outside of arena" },
        { "TANK",      "Swap after Liquify" },
        { "TANK",      "Infest - run behind group" },
        { "HEALER",    "Regret your decision to play a healer" }
    }, -- Queen Ansurek

    --------------------
    -- GRIM BATOL   ----
    --------------------
    [224152] = {
        { "TANK", "Brutal Strike: Tank targeted phys hit" },
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

    --------------------
    -- BOSSES        ----
    --------------------
    [39625] = {
        { "Important", "Commanding Roar: Move to clear area" },
        { "Important", "Shadowflame Breath: 3 Drakes breath across 1/4 of the platform each after 8s, dealing shadowflame damage to anyone hit" },
        { "Important", "Rock Spike: Drop at edge of room" },
        { "TANK",      "Skullsplitter: Defensive! Tank targeted phys channel, hits every 1s for 2s and applies a stacking Bleed for 8s" }
    }, -- General Umbriss

    [40177] = {
        { "Important", "Forge Weapon: The boss forges a new weapon (Axe > Sword > Mace), doing a channeled fire AoE that ticks every 1s for 4s in the process" },
        { "Important", "Fiery Cleave: Tank at edge!  Random target frontal (does not follow) that deals phys dam and leaves behind Molten Pool puddles for 5min" },
        { "TANK",      "Molten Flurry: Defensive!  Tank targeted phys and fire channel, hits every 1s for 6s and applies a 6s DoT to 3 random players which drops Molten Pools on expiration" },
        { "TANK",      "Molten Mace: KITE!  The boss gains 1000% increased melee damage but is slowed by 50% and drops Molten Pools beneath himself for 10s" }
    }, -- Forgemaster Throngus

    [40319] = {
        { "Interrupts", "Shadowflame Bolt: Tank targeted shadowflame hit" },
        { "Important",  "Invocation of Shadowflame: Spawns an add (2 in P2) randomly around the room that fixates a random player, dealing massive party damage if they reach them" },
        { "Important",  "Curse of Entropy: 20s Curse DoT on 3 players that absorbs healing equal to 30% of their health and slows by 50%" },
        { "Important",  "Twilight Buffet: AoE shadowflame hit and knockback that spawns 4 Twighlight Winds for 1.5min that deal shadowflame damage to anyone they touch" },
        { "TANK",       "Devouring Flame: Tank targeted frontal (does not follow) that deals shadow damage" }
    }, -- Drahga Shadowburner

    [40484] = {
        { "Important",  "Void Surge: Don't stand in tentacles" },
        { "Important",  "Shadow Gale: Shadows reduce the safe area in the room over 15s, staying at the smallest size for 6s before disappearing" },
        { "Important",  "Abyssal Corruption: 6yd AoE shadow ticks around 3 players for 8s" },
        { "Interrupts", "Void Infusion: Spawns several Mutated Hatchling adds (listed above) from the eggs at the sides of the room" },
        { "TANK",       "Crush: Defensive! Tank targeted phys and shadow hit that knocks them back" }
    }, -- Erudax, the Duke of Below

    
    --------------------
    -- NECROTIC WAKE ----
    --------------------

    -- Blight Bag
    [165138] = { -- Placeholder ID
        { "Important", "Disgusting Guts: 40yd AoE Disease DoT for 4s on death" }
    },

    -- Corpse Harvester
    [166302] = { -- Placeholder ID
        { "Important",  "Throw Flesh: Random target phys hit" },
        { "Interrupts", "Drain Fluids: Random target plague channel and incapacitate for 4s" }
    },

    -- Stitched Vanguard
    [163121] = { -- Placeholder ID
        { "Soothe/Purge", "Seething Rage: Stacking 10% attack speed increase enrage on successful melee attacks" },
        { "TANK",         "Bone Claw: Tank targeted phys hit" }
    },

    -- Zolramus Gatekeeper
    [165137] = { -- Placeholder ID
        { "Important", "Summon Soldier: Spawns a Patchwerk Soldier from a nearby portal every ~12s while in combat" },
        { "Dispel",    "Clinging Darkness: Random target Magic DoT for 30s" },
        { "TANK",      "Necrotic Bolt: Tank targeted shadow hit and healing absorb" },
        { "Avoid",     "Wrath of Zolramus: Channeled AoE shadow hits, ticks every 0.1s for 5s" }
    },

    -- Zolramus Bonecarver
    [163619] = { -- Placeholder ID
        { "TANK", "Boneflay: Tank targeted phys hit and 10s Bleed that reduces max health by 15%" }
    },

    -- Zolramus Sorcerer
    [163128] = { -- Placeholder ID
        { "Interrupts", "Necrotic Bolt: Tank targeted shadow hit and healing absorb" },
        { "Avoid",      "Shadow Well: Tank targeted 3yd puddle" }
    },

    -- Zolramus Necromancer
    [163618] = { -- Placeholder ID
        { "Important",  "Undying Minions: Nearby Brittlebone minions are unkillable and heal 10% health per second, but die when the necromancer is killed" },
        { "Interrupts", "Necrotic Bolt: Tank targeted shadow hit and healing absorb" },
        { "Avoid",      "Grim Fate: 6yd AoE shadow hit around a random player after 4s" },
        { "Important",  "Animate Dead: 3s channel that spawns 3 4yd swirlies over the duration which create a random Brittlebone minion" }
    },

    -- Brittlebone Mage
    [163126] = { -- Placeholder ID
        { "Interrupts", "Frostbolt: Random target frost hit and stacking 10% Magic slow for 8s" }
    },

    -- Brittlebone Crossbowman
    [166079] = { -- Placeholder ID
        { "Important", "Shoot: Random target phys hit" }
    },

    -- Zolramus Bonemender
    [165222] = { -- Placeholder ID
        { "Interrupts", "Bonemend: Heals the target for 10% max health" },
        { "Important",  "Final Bargain: Heals the target for 80% max health and deals 4% max health in damage to it every second for 20s" }
    },

    -- Skeletal Marauder
    [165919] = { -- Placeholder ID
        { "TANK",   "Gruesome Cleave: Tank targeted 8yd frontal (follows) phys hit" },
        { "Avoid",  "Boneshatter Shield: Self absorb shield for 8s that deals massive damage to the caster if broken before it expires" },
        { "Danger", "Rasping Scream: 15yd AoE Magic Fear for 5s" }
    },

    -- Nar'zudah
    [165824] = { -- Placeholder ID
        { "Interrupts",   "Necrotic Bolt: Tank targeted shadow hit and healing absorb" },
        { "Avoid",        "Death Burst: 6yd AoE swirlies that deal shadow damage and silence for 4s" },
        { "Important",  "Dark Shroud: Physical damage immunity and pulsing party damage for 12s, Magic effect" }
    },

    -- Skeletal Monstrosity
    [165197] = { -- Placeholder ID
        { "TANK",  "Shatter: Tank targeted phys hit" },
        { "Avoid", "Frigid Spikes: 4yd AoE swirlies under all players that deal frost damage and knock up" },
        { "Avoid", "Reaping Winds: 60% slow and pull in for 4s that does a 16yd AoE phys hit afterwards" }
    },

    -- Corpse Collector
    [173016] = { -- Placeholder ID
        { "Important",  "Throw Flesh: Random target phys hit" },
        { "Interrupts", "Drain Fluids: Random target plague channel and incapacitate for 4s" },
        { "Danger",     "Goresplatter: 40yd AoE plague hit and 6s Disease DoT" }
    },

    -- Kyrian Stitchwerk
    [172981] = { -- Placeholder ID
        { "TANK", "Tenderize: Tank targeted phys hit and stacking 12% phys damage taken increase for 16s" },
        { "TANK", "Mutilate: Tank targeted phys hit (2x bigger hit than Tenderize)" }
    },

    -- Flesh Crafter
    [165872] = { -- Placeholder ID
        { "Avoid",      "Throw Cleaver: Random target line attack (follows initially then locks in) after 4s" },
        { "Interrupts", "Repair Flesh: Channeled heal for 5% max hp per second on a random construct" }
    },

    -- Loyal Creation
    [165911] = { -- Placeholder ID
        { "TANK",      "Bone Claw: Tank targeted phys hit" },
        { "Avoid",     "Spine Crush: 8yd AoE phys hit and knockback" },
        { "Important", "Vengeful Rage: 75% attack speed increase if linked Flesh Crafter dies, Enrage effect" }
    },

    -- Stitching Assistant
    [173044] = { -- Placeholder ID
        { "Important",  "Throw Flesh: Random target phys hit" },
        { "Avoid",      "Throw Cleaver: Random target line attack (follows initially then locks in) after 4s" },
        { "Interrupts", "Drain Fluids: Random target plague channel and incapacitate for 4s" }
    },

    -- Separation Assistant
    [167731] = { -- Placeholder ID
        { "TANK",      "Separate Flesh: Tank targeted phys hit" },
        { "Avoid",     "Throw Cleaver: Random target line attack (does not follow)" },
        { "Important", "Morbid Fixation: Random target fixate for 8s" }
    },

    -- Goregrind
    [163621] = { -- Placeholder ID
        { "TANK",  "Tenderize: Tank targeted phys hit and stacking 12% phys damage taken increase for 16s" },
        { "TANK",  "Mutilate: Tank targeted phys hit (2x bigger hit than Tenderize)" },
        { "Avoid", "Gut Slice: Random target 10yd frontal (does not follow)" }
    },

    -- Rotspew
    [163620] = { -- Placeholder ID
        { "Important", "Disease Cloud: Constant plague damage ticks within 8yds" },
        { "TANK",      "Mutilate: Tank targeted phys hit (2x bigger hit than Tenderize)" },
        { "Avoid",     "Spew Disease: Random target plague hit, spawns an 8yd puddle" }
    },

    --------------------
    -- BOSSES
    --------------------

    -- Blightbone
    [162691] = { -- Placeholder ID
        { "TANK",      "Crunch: Tank targeted phys hit" },
        { "Important", "Heaving Retch: Random target 100yd frontal (follows), deals nature damage and applies a 12s Disease DoT" },
        { "Avoid",     "Fetid Gas: 8yd puddle deals nature dam and pacifies" }
    },

    -- Amarth
    [163157] = { -- Placeholder ID
        { "Interrupts",   "Necrotic Bolt: Random target shadow hit and healing absorb" },
        { "Soothe/Purge", "Unholy Frenzy: 40% attack speed increase" },
        { "Important",    "Land of the Dead: Spawns 5 Reanimated adds with 'Brittlebone' abilities" }
    },

    -- Surgeon Stitchflesh
    [162689] = { -- Placeholder ID
        { "Avoid",     "Meat Hook: Random target line attack that pulls the first thing hit" },
        { "TANK",      "Sever Flesh: Tank targeted phys hit" },
        { "Important", "Awaken Creation: Summons a Creation mob" }
    },

    -- Nalthor the Rimebinder
    [162693] = { -- Placeholder ID
        { "TANK",      "Icy Shard: Tank targeted phys hit" },
        { "Dispel",    "Frozen Binds: Random target Magic DoT, immobilizes for 12s" },
        { "Avoid",     "Comet Storm: 3yd swirlies under all players" },
        { "Important", "Dark Exile: Random DPS exiled to side platform" }
    },

    ----------------------------------
    --- SIEGE OF BORALUS -------------
    ----------------------------------
    -- Chopper Redhook
    [128650] = {
        { "Important",     "On The Hook = Kite onto bombs ASAP" },
        { 'TANK',      'Aggro Adds and drag under boss for cleave' },
        { "Defensives", "Defensive to soak bombs if boss doesn't get kited into them all" },
        { "Dodge", "SNIPER CORRIDOR AFTER! Watch chat emotes" },

    },
    
    [129208] = {
        { 'TANK', 'Aggro adds after Withdraw' },
        { 'Important', 'Slow/Snare Evasive buff' },
        { "Dodge", "SNIPER CORRIDOR AFTER! Watch chat emotes" },
    },
    
    -- Hadal Darkfathom
    [128651] = {
        { 'TANK', 'Move boss from puddles after Break Water' },
        { 'TANK', 'LOS Tidal Surge 2x in a row' },
    },
    
    -- Viq'Goth
    [128652] = {
        { 'TANK', 'Demolishing Terror first, always tank it' },
    },
    
    --------------------------
    ---STONEVAULT
    --------------------------
    
    -- EDNA
    [210108] = {
        { 'Important', 'Clear a few spikes at a time w/ arrow attack BUT NOT ALL' },
        { 'Important', 'Do NOT Stack' },
        { 'TANK',      'Seismic Smash - Physical Tankbuster DEFENSIVE FIRST ONE' },
        { 'TANK', 'Save Magic Dot to Dispel before Smash lands' },
    },
    
    -- Skarmorak
    [210156] = {
        { 'Important', 'Destroy ONE shard at a time' },
        { 'Important', 'DPS: Pick up 1-3 Orbs at a time' },
    },
    
    -- Dorlita
    [213216] = {
        { 'Important', 'KICK BROKK Molten Metal ASAP' },
    },
    
    -- Brokk
    [213217] = {
        { 'Important', 'KICK Molten Metal ASAP' },
    },
    
    -- Void Speaker Eirich
    [213119] = {
        { 'Important', 'Drop Blue circle at edge of room NOT by portals' },
        { 'Important', 'Corruption - stand near a portal NOT IN IT' },
        { 'Important', 'Avoid Frontal Cone' },
    },
    
    -----------------------------
    -- MISTS OF TIRNA SCITHE ----
    -----------------------------
    
    -- Ingra Maloch 1
    [164567] = {
        { 'Important', 'DPS: Save CDs until boss is not buffed by Droman' },
        { 'Important', 'Interrupt spirit bolt always' },
        { 'TANK', 'Face Droman AWAY from group and avoid frontal' },
    },
    
    -- Ingra Maloch 2
    [170229] = {
        { 'Important', 'DPS: Save CDs until boss is not buffed by Droman' },
        { 'Important', 'Interrupt spirit bolt always' },
        { 'TANK',      'Face Droman AWAY from group and avoid frontal' },
    },
    
    -- Mistcaller
    [170217] = {
        { 'TANK', 'INTERRUPT PATTY CAKE, only tank can interrupt this' },
        { 'Important', 'Avoid vulpin even if not focused, slow it' },
        { 'Important', 'Defensive during Guessing Game ramping dmg' },
    },
    
    -- Tred'ova
    [164517] = {
        { 'Important', 'Avoid fixate larva, use slows' },
        { 'Important', 'DPS break tank tether asap' },
    },
    
    -----------------------------
    -- Ara'Kara City of Echoes --
    -----------------------------
    
    ---Avanoxx
    [213179] = {
        { 'Important', 'Kill adds, avoid swirls' },
        { 'TANK', 'Keep boss away from adds, drag opposite spawning eggs' },
    },
    
    [215405] = {
        { 'Important', 'Avoid Swirlies' },
        { 'Important', 'At 100 Energy stay in safe circle' },
        { 'TANK',      'During 100 energy, tank at right edge of circle and face outward' },
        { 'TANK',      'Pick up webmage adds as they spawn' },
        { 'TANK', 'Keep him toward center of room as much as possible' },
    },
    
    [215407] = {
        { 'Important', 'Kill adds to spawn goos' },
        { 'Important', 'Stand in goo pool during pull then kill/CC/interrupt roots' },
        { 'Important', 'Poison dispel the waves' },
        { 'TANK',      'Move boss from puddles' },
        { 'TANK', 'Keep Black Ox statue down in middle of room to taunt oozes from' },
    },
    
    -----------------------------
    -- Dawnbreaker --------------
    -----------------------------
    [211087] = {
      { 'TANK', 'Defensive when Obsidian Beams spawn' },
      { 'Important', 'Remember to Skyride' },
    },
    
    [211089] = {
        { 'Important', 'Aim dark orb up/down hill not into wall' },
    },
    
    [213937] = {
        { 'Important', 'DPS throw bombs, 3x per wave' },
    },
    
    -----------------------------
    -- City of Threads --------------
    -----------------------------
    
    ---Orator KrixVizk
    [216619] = {
        { 'TANK',       '100 Energy Move boss immediately after Vociferous Indoctrination' },
        { 'TANK',       'Move boss as little as possible' },
        { 'Defensives', 'Indoctrination Use defensive (Mixed dmg)' },
    },
    
    --Fangs of the Queen
    [216648] = {
        { 'TANK', 'P2 - Defensive during Rime Dagger' },
        { 'Important', 'Avoid lines and swirls' },
    },
    [216649] = {
        { 'TANK',      'P2 - Defensive during Rime Dagger' },
        { 'Important', 'Avoid lines and swirls' },
    },
    
    -- Coaglamation
    [216320] = {
        { 'TANK', 'Kite around edge of room' },
        { 'TANK', 'Defensive - Oozing Smash' },
        { 'Important', 'After knockback, absorb 2-3 orbs' },
    },
    
    [216658] = {
        { 'Important', 'Stack and rotate around room together' },
        { 'TANK', 'Process of Elimination - defensive & move to middle of room to avoid group' },
    },
    
    ----------------0-----------------
    [0] = { { "-" } }

}
