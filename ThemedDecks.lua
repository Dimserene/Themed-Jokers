--- STEAMODDED HEADER
--- MOD_NAME: Themed Decks
--- MOD_ID: ThemedDecks
--- MOD_AUTHOR: [Blizzow]
--- MOD_DESCRIPTION: Adds Decks for Themed Joker starts

----------------------------------------------
------------MOD CODE -------------------------

----------------------------------------------
-------------------UTIL-----------------------

local cosmosjoker ={
    'j_cosmicvirgo',
    'j_cosmicpisces',
    'j_cosmicaquarius',
    'j_cosmicleo',
    'j_cosmicgemini',
    'j_cosmiclibra',
    'j_cosmicsagittarius'
}
local mischiefjoker ={
    'j_firstpieceofthemischievousone',
    'j_secondpieceofthemischievousone',
    'j_thirdpieceofthemischievousone',
    'j_fourthpieceofthemischievousone',
    'j_cultistofthemischievousone'
}


local localization = {
    cosmicdeck = {
        name = "Cosmic Constellation",
        text = {
        "Start the game with one",
        "{C:purple}The Cosmos{} and",
        "{C:purple}The Sign{} tarot card"        
        }
    },
    mischiefdeck = {
        name = "Deck of the Mischievous One",
        text = {
        "Start the game with one",
        "{C:attention}\"Cultist of the Mischievous One\""        
        }
    },
}


local decks = {
    cosmicdeck = {
        name = "Cosmic Constellation",
        config = { cosmicstart = true},
        sprite = { x = 0, y = 0 }
    },
    mischiefdeck = {
        name = "Deck of the Mischievous One",
        config = { mischiefstart = true},
        sprite = { x = 0, y = 0 }
    },
}

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Backapply_to_runRef(arg_56_0)
    if arg_56_0.effect.config.mischiefstart then
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_cultistofthemischievousone', nil)
                card:add_to_deck()
                G.jokers:emplace(card)
                return true
            end
        }))
    end
    if arg_56_0.effect.config.cosmicstart then
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_cosmos', nil)
                card:add_to_deck()
                G.consumeables:emplace(card)
                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_constellation', nil)
                card:add_to_deck()
                G.consumeables:emplace(card)
                return true
            end
        }))
    end
end


function SMODS.INIT.ThemedJokerDecks()    
    for k, v in pairs(decks) do
        local newDeck = SMODS.Deck:new(v.name, k, v.config, v.sprite, localization[k])
        newDeck:register()        
    end
end

----------------------------------------------
------------MOD CODE END----------------------
