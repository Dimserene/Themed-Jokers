--- STEAMODDED HEADER
--- MOD_NAME: Themed Jokers
--- MOD_ID: ThemedJokers
--- MOD_AUTHOR: [Blizzow]
--- MOD_DESCRIPTION: A bunch of themed Jokers. WIP

----------------------------------------------
------------MOD CODE -------------------------

---Config---
config = {
vanillaart=true, --true/false enables alternative artworks

}
---UTILITY METHODS---
function destroyCard(self,sound)
    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound(sound, math.random()*0.2 + 0.9,0.5)
            self.T.r = -0.2
            self:juice_up(0.3, 0.4)
            self.states.drag.is = true
            self.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                        G.jokers:remove_card(self)
                        self:remove()
                        self = nil
                    return true; end})) 
            return true
        end
    })) 
    self.gone = true
end

function shakecard(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end
function fakemessage(_message,_card,_colour)
    G.E_MANAGER:add_event(Event({ trigger = 'after',delay = 0.15,       
        func = function() card_eval_status_text(_card, 'extra', nil, nil, nil, {message = _message, colour = _colour, instant=true}); return true
        end}))
    return
end


function poll_enhancement(seed)
    local enhancements = {}
    --add all enhancements but m_stone to list
    for k, v in pairs() do
        if v.key ~= 'm_stone' then 
            enhancements[#enhancements+1] = v
        end
    end
    return pseudorandom_element(enhancements, pseudoseed(seed))
end

function poll_seal(seed)
    local seals = {}
    for k, v in pairs(G.P_SEALS) do
        seals[#seals+1] = v
    end
    return pseudorandom_element(seals, pseudoseed(seed)).key
end

function poll_FromTable(_table,seed,filter)
    local items = {}    
    for k, v in pairs(_table) do
        if v.key ~= filter then
            items[#items+1] = v
        end        
    end
    return pseudorandom_element(items, pseudoseed(seed))
end


    --G.P_TAGS 
    --G.P_CARDS
    --G.P_SEALS
function randomFromTable(source)
    local keys = {} 
    for k in pairs(source) do
        table.insert(keys, k)
    end    
    local choiceIndex = math.random(1,#keys) 
    local choiceKey = keys[choiceIndex] 
    local choice = source[choiceKey]
    return {key = choiceKey, value = choice}
end

function checkforcosmicophiuchus()
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if other_joker.ability.name == "Cosmic - Ophiuchus" then
            return true
        end        
    end
    return false
end

function addtokentocosmic(card,increment)
    if checkforcosmicophiuchus()==true then
        increment=increment*3
    end
    if string.match(card.ability.name,"Cosmic -") and card.ability.extra.tokens ~= nil and increment and increment ~=0  then
        card.ability.extra.tokens=card.ability.extra.tokens+increment
        fakemessage("+"..increment.." Cosmic",card,G.C.PURPLE)
    end        
end


function addtokentoallcosmic(increment)
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if string.match(other_joker.ability.name,"Cosmic -") and other_joker.ability.extra.tokens ~= nil and increment and increment ~=0  then
           addtokentocosmic(other_joker,increment)
        end        
    end
end

function countcosmictokens()
    local count=0
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if other_joker and string.match(other_joker.ability.name,"Cosmic -") and other_joker.ability.extra.tokens~=nil then
            count=count+other_joker.ability.extra.tokens
        end
    end
    return count
end

function countpieces()
    local count=0
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if string.match(other_joker.ability.name,"of the Mischievous") then
            count=count+1
        end
    end
    return count-1
end

function trigger_badkarma(card)
    fakemessage(localize('k_o_unlucky'),card,G.C.RED)
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if other_joker.ability.name=="Omen - Thirteen" then
            other_joker.ability.extra.x_mult=other_joker.ability.extra.x_mult+0.25
            shakecard(other_joker)
            fakemessage("+X0.25 Mult",other_joker,G.C.RED)
        end
    end
end

function trigger_goodkarma(card)
    fakemessage(localize('k_o_lucky'),card,G.C.GREEN)
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if other_joker.ability.name=="Omen - Seven" then
            other_joker.ability.extra.x_mult=other_joker.ability.extra.x_mult+0.25
            shakecard(other_joker)
            fakemessage("+X0.25 Mult",other_joker,G.C.RED)
        end
    end
end

function mod_badkarma(increment)
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if string.match(other_joker.ability.name,"Omen -") then
            other_joker.ability.extra.negativeodds=other_joker.ability.extra.negativeodds+increment
            if other_joker.ability.extra.negativeodds < 1 then
                other_joker.ability.extra.negativeodds=1
            end
            if increment > 0 then
                fakemessage("+ Karma",other_joker,G.C.RED)
            else
                fakemessage("- Karma",other_joker,G.C.RED)
            end
        end 
    end
end
function mod_goodkarma(increment)
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if string.match(other_joker.ability.name,"Omen -") then
            other_joker.ability.extra.positiveodds=other_joker.ability.extra.positiveodds+increment
            if other_joker.ability.extra.positiveodds < 1 then
                other_joker.ability.extra.positiveodds=1
            end
            if increment > 0 then
                fakemessage("+ Karma",other_joker,G.C.GREEN)
            else
                fakemessage("- Karma",other_joker,G.C.GREEN)
            end
        end 
    end
end


function checkforpieces(card)
    card.ability.extra.pieceone=0
    card.ability.extra.piecetwo=0
    card.ability.extra.piecethree=0
    card.ability.extra.piecefour=0
    for i= 1, #G.jokers.cards do
        other_joker = G.jokers.cards[i]
        if other_joker.ability.name=="First Piece of the Mischievous One" then card.ability.extra.pieceone=1 end
        if other_joker.ability.name=="Second Piece of the Mischievous One" then card.ability.extra.piecetwo=1 end
        if other_joker.ability.name=="Third Piece of the Mischievous One" then card.ability.extra.piecethree=1 end
        if other_joker.ability.name=="Fourth Piece of the Mischievous One" then card.ability.extra.piecefour=1 end
    end
end

function addjoker(joker)
    local card = create_card('Joker', G.jokers, nil, 0, nil, nil, joker, nil)
    card:add_to_deck()
    G.jokers:emplace(card)
    G.GAME.used_jokers[joker] = true
end




local jokers = {
    jimbothemischievousone = {
        name = "Jimbo the Mischievous One",
        text = {
            "When selecting a {C:attention}Blind{}, destroy all",
            "{C:attention}\"Pieces of the Mischievous One\"{} you have.",
            "Gains {X:mult,C:white} X1.5{} for each Joker destroyed by this effect",	
            "{C:inactive}(Currently {X:mult,C:white} X#1#{} {C:inactive}Mult)",
			"{C:inactive}(He returned to spread mischief once more.)"
		},
		ability = {extra={x_mult=6.0}},
		pos = { x = 0, y = 1 },
        rarity= 4,
        cost = 50,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker == self then
                return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                Xmult_mod = self.ability.extra.x_mult
                }
            end
            if context.setting_blind then
                for i= 1, #G.jokers.cards do
                    if string.match(G.jokers.cards[i].ability.name,"Piece of the Mischievous One") then
                        destroyCard(G.jokers.cards[i],'glass1')
                        self.ability.extra.x_mult=self.ability.extra.x_mult+1.5
                        fakemessage("+ x1.5",self,G.C.MULT)
                    end
                end
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.x_mult}
        end        
	},
    firstpieceofthemischievousone = {
        name = "First Piece of the Mischievous One",
        text = {
            "{C:mult}+#1#{} Mult",
            "Gains {C:mult}+1{} Mult for every other",
            "{C:attention}\"The Mischievous One\"{} Joker.",
			"{C:inactive}(A piece of Jimbo the Mischievious One.)",
			"{C:inactive}(Whosoever restores him will know infinite power.)"          
		},
		ability = {extra={mult=1}},
		pos = { x = 1, y = 1 },
        rarity=1,
        cost = 3,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end
            end
            self.ability.extra.mult=1+countpieces()
        end,
        loc_def=function(self)
            return {self.ability.extra.mult}
        end        
	},
    secondpieceofthemischievousone = {
        name = "Second Piece of the Mischievous One",
        text = {        
            "{C:mult}+#1#{} Mult",
            "Gains {C:mult}+1{} Mult for every other",
            "{C:attention}\"The Mischievous One\"{} Joker.",
			"{C:inactive}(A piece of Jimbo the Mischievious One.)",
			"{C:inactive}(Whosoever restores him will know infinite power.)"                 
		},
		ability = {extra={mult=1}},
		pos = { x = 2, y = 1 },
        rarity=1,
        cost = 3,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end
            end
            self.ability.extra.mult=1+countpieces()
        end,
        loc_def=function(self)
            return {self.ability.extra.mult}
        end        
	},
    thirdpieceofthemischievousone = {
        name = "Third Piece of the Mischievous One",
        text = {          
            "{C:mult}+#1#{} Mult",
            "Gains {C:mult}+1{} Mult for every other",
            "{C:attention}\"The Mischievous One\"{} Joker.",
			"{C:inactive}(A piece of Jimbo the Mischievious One.)",
			"{C:inactive}(Whosoever restores him will know infinite power.)"                 
		},
		ability = {extra={mult=1}},
		pos = { x = 3, y = 1 },
        rarity=1,
        cost = 3,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end
            end
            self.ability.extra.mult=1+countpieces()
        end,
        loc_def=function(self)
            return {self.ability.extra.mult}
        end        
	},
    fourthpieceofthemischievousone = {
        name = "Fourth Piece of the Mischievous One",
        text = {         
            "{C:mult}+#1#{} Mult",
            "Gains {C:mult}+1{} Mult for every other",
            "{C:attention}\"The Mischievous One\"{} Joker.",
			"{C:inactive}(A piece of Jimbo the Mischievious One.)",
			"{C:inactive}(Whosoever restores him will know infinite power.)"            
		},
		ability = {extra={mult=1}},
		pos = { x = 4, y = 1 },
        rarity=1,
        cost = 3,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end
            end
            self.ability.extra.mult=1+countpieces()
        end,
        loc_def=function(self)
            return {self.ability.extra.mult}
        end        
	},
    cultistofthemischievousone = {
        name = "Cultist of the Mischievous One",
        text = {
            "When selecting a {C:attention}Blind{}, create 1 {C:attention}\"Piece of the Mischievous One\"{}",         
			"Gains {X:mult,C:white} X0.2{} for every {C:attention}\"The Mischievous One\"{} Joker.",
            "At the end of a {C:attention}Round{}, if you have all 4 pieces,",
            "{C:red}destroy{} them and this card, create 1 {C:legendary}\"Jimbo the Mischievous One\"{}",
            "{C:inactive}(Must have room. Currently: {X:mult,C:white} X#1#{}{C:inactive} Mult.)",
			"{C:inactive}(These cultists worship Jimbo like a god.)"            
		},
		ability = {extra={x_mult = 1.2,pieceone=0,piecetwo=0,piecethree=0,piecefour=0}},
		pos = { x = 5, y = 1 },
        rarity = 1,
        cost = 4,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker == self then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                    Xmult_mod = self.ability.extra.x_mult
                }
            end
            if context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit then
            checkforpieces(self)
                if self.ability.extra.pieceone==0 then
                    addjoker('j_firstpieceofthemischievousone')
                elseif self.ability.extra.piecetwo==0 then
                    addjoker('j_secondpieceofthemischievousone')
                elseif self.ability.extra.piecethree==0 then
                    addjoker('j_thirdpieceofthemischievousone')
                elseif self.ability.extra.piecefour==0 then
                    addjoker('j_fourthpieceofthemischievousone')                
                end            
            end
            if context.end_of_round and not (context.individual or context.repetition) then
                checkforpieces(self)
                if self.ability.extra.pieceone==1 and self.ability.extra.piecetwo==1 and self.ability.extra.piecethree==1 and self.ability.extra.piecefour==1 then
                    for i= 1, #G.jokers.cards do
                        if string.match(G.jokers.cards[i].ability.name,"Piece of the Mischievous One") then
                            destroyCard(G.jokers.cards[i],'glass1')
                        end
                    end                
                    addjoker('j_jimbothemischievousone')
                    destroyCard(self,'holo1')
                    return{ message = localize('k_return'), colour=G.C.LEGENDARY, card=self}
                end
            end
            local count =0
            for i= 1, #G.jokers.cards do
                if string.match(G.jokers.cards[i].ability.name,"the Mischievous One") then
                    count=count+1
                end
            end
            self.ability.extra.x_mult=1+(0.2*count)
        end,
        loc_def=function(self)
            return {self.ability.extra.x_mult}
        end        
	},
    cosmiccapricorn = {
        name = "Cosmic - Capricorn",
        text = {         
            "Scored cards gain {C:chips}+#2#{} Chips permanently.",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}2{} scored.",
			"{C:inactive}(Steadfast ambition guides Capricorn's climb.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"                
		},
		ability = {extra={tokens=0,bonuschips=3}},
		pos = { x = 0, y = 2 },
        rarity=1,
        cost = 4,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.individual and context.cardarea == G.play then
                if not context.blueprint and (context.other_card:get_id() == 2) then
                    addtokentocosmic(self,1)
                end 
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra.bonuschips
                return {
                    extra = {message = localize('k_c_upgrade'), colour = G.C.PURPLE},
                    colour = G.C.PURPLE,
                    card = context.other_card
                    }                      
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens, self.ability.extra.bonuschips}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end       
	},
    cosmicaquarius = {
        name = "Cosmic - Aquarius",
        text = {         
            "{C:green}#2# in #3#{} chance to gain {C:money}$1{} per card scored.",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}3{} scored.",
			"{C:inactive}(Innovative vision shapes Aquarius' path.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"       
		},
		ability = {extra={tokens=0,odds=6}},
		pos = { x = 1, y = 2 },
        rarity=1,
        cost = 4,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.individual and context.cardarea == G.play then
                if not context.blueprint and (context.other_card:get_id() == 3) then
                    addtokentocosmic(self,1)
                end                
                if pseudorandom('aquarius') < G.GAME.probabilities.normal/self.ability.extra.odds then
                return {                
                message = localize('k_c_dollars'),
                colour = G.C.PURPLE,
                ease_dollars(1),
                card = self
                }
                end                
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.odds}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end        
	},
    cosmicpisces = {
        name = "Cosmic - Pisces",
        text = {         
            "Gains {C:mult}+1{} Mult and {C:purple}+1 Cosmic-Token{}.",
            "per {C:attention}4{} scored. {C:inactive}(Currently {C:mult}+#2#{} {C:inactive}Mult)",
			"{C:inactive}(Boundless empathy guides Pisces' journey.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"             
		},
		ability = {extra={tokens=0,mult=3}},
		pos = { x = 2, y = 2 },
        rarity=1,
        cost = 4,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if not context.blueprint and  context.individual and context.cardarea == G.play and (context.other_card:get_id() == 4) then
                addtokentocosmic(self,1)
                self.ability.extra.mult=self.ability.extra.mult+1                
                return {                
                message = localize('k_c_upgrade'),
                colour = G.C.PURPLE,
                card = self
                }                            
            end
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end 
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.mult}
        end,  
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end     
	},
    cosmicaries = {
        name = "Cosmic - Aries",
        text = {         
            "Gains {C:chips}+10{} Chips and {C:purple}+1 Cosmic-Token{}.",
            "per {C:attention}5{} scored. {C:inactive}(Currently {C:chips}+#2#{} {C:inactive}Chips)",
			"{C:inactive}(Unyielding courage fuels Aries' pursuits.)" ,
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"                        
		},
		ability = {extra={tokens=0,chips=30}},
		pos = { x = 3, y = 2 },
        rarity=1,
        cost = 4,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if not context.blueprint and context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5) then
                addtokentocosmic(self,1)
                self.ability.extra.chips=self.ability.extra.chips+10                
                return {                
                message = localize('k_c_upgrade'),
                colour = G.C.PURPLE,
                card = self
                }                            
            end
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                    chip_mod = self.ability.extra.chips
                    }
                end 
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chips}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end         
	},
    cosmictaurus = {
        name = "Cosmic - Taurus",
        text = {     
            "Gains {C:green}1%{} chance per {C:purple}Cosmic-Token{} on this",
            "to {C:attention}enhance{} scored cards. {C:inactive}(Currently {C:green}#2#%{}{C:inactive} chance)",    
            "{C:purple}+1 Cosmic-Token{} per {C:attention}6{} scored.",
			"{C:inactive}(Enduring patience fortifies Taurus' strides.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,chance=5}},
		pos = { x = 4, y = 2 },
        rarity=2,
        cost = 8,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.chance=5+self.ability.extra.tokens
            if context.individual and context.cardarea == G.play then
                if not context.blueprint and  (context.other_card:get_id() == 6) then
                    addtokentocosmic(self,1)
                end
                --add random edition to card
                if pseudorandom('taurus') < self.ability.extra.chance/100 then
                    local card = context.other_card
                    
                    if card.config.center == G.P_CENTERS.c_base then --if card is c_base/without enhancements
                    local enhancement = poll_FromTable(G.P_CENTER_POOLS["Enhanced"],'taurus','m_stone')
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('card1', 5);card:juice_up(0.3, 0.3);return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('tarot1', 5);card:set_ability(enhancement);return true end }))
                    fakemessage(localize('k_c_upgrade'),self,G.C.PURPLE)
                    end    
                end                                
            end            
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chance}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'enhancement' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicgemini = {
        name = "Cosmic - Gemini",
        text = {   
            "Gains {C:green}0.5%{} chance per {C:purple}Cosmic-Token{} on this",
            "to {C:attention}retrigger{} scored cards. {C:inactive}(Currently {C:green}#2#%{}{C:inactive} chance)",      
            "{C:purple}+1 Cosmic-Token{} per {C:attention}7{} scored.",
			"{C:inactive}(Curious intellect propels Gemini's exploration.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,chance=5}},
		pos = { x = 5, y = 2 },
        rarity=2,
        cost = 8,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.chance=5+(self.ability.extra.tokens*0.25)
            if self.ability.extra.chance>120 then
                self.ability.extra.chance=120
            end
            if not context.blueprint and  context.individual and context.cardarea == G.play and (context.other_card:get_id() == 7)  then
                addtokentocosmic(self,1)           
            end
            
            
            if  context.repetition and context.cardarea == G.play then
                local _repetitions=math.floor((self.ability.extra.chance/100))
                --if 120% chance = +1 repetition guaranteed. after that 120-(100*1)/100 chance for +2 
                if pseudorandom('gemini') < (self.ability.extra.chance-(100*_repetitions))/100 then
                    _repetitions=_repetitions+1
                end                
                return {
                    message = localize('k_again_ex'),
                    repetitions = _repetitions,
                    card = context.other_card
                }
            end            
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chance}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'retrigger' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmiccancer = {
        name = "Cosmic - Cancer",
        text = {      
            "Gains {C:green}1%{} chance per {C:purple}Cosmic-Token{} on this",
            "to add a {C:attention}Seal{} to discarded cards. {C:inactive}(Currently {C:green}#2#%{}{C:inactive} chance)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}8{} scored.",
			"{C:inactive}(Emotional depth enriches Cancer's connections.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,chance=5}},
		pos = { x = 6, y = 2 },
        rarity=2,
        cost = 8,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.chance=5+self.ability.extra.tokens
            
            if not context.blueprint and  context.individual and context.cardarea == G.play and (context.other_card:get_id() == 8)  then
                addtokentocosmic(self,1)
            end
            if context.discard and not context.other_card.debuff and pseudorandom('cancer') < self.ability.extra.chance/100 then                
                local card=context.other_card
                if not card.seal then
                    G.E_MANAGER:add_event(Event({func = function()
                        play_sound('tarot1')
                        self:juice_up(0.3, 0.5)
                        return true end }))
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        seal=poll_seal('cancer')
                        card:set_seal(seal, nil, true)
                        return true end }))
                        
                        return {
                            message = localize('k_c_seal'),
                            colour = G.C.PURPLE,
                            card = card
                        }
                end
            end     
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chance}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'seals' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicleo = {
        name = "Cosmic - Leo",
        text = {         
            "Gains {C:green}1%{} chance per {C:purple}Cosmic-Token{} on this",
            "to add a {C:attention}Edition{} to discarded cards. {C:inactive}(Currently {C:green}#2#%{}{C:inactive} chance)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}9{} scored.",
			"{C:inactive}(Majestic passion ignites Leo's pursuits.)",
            "{C:inactive}({C:purple}Cosmic-Tokens:{} {X:purple,C:white}#1#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,chance=5}},
		pos = { x = 7, y = 2 },
        rarity=2,
        cost = 8,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.chance=5+self.ability.extra.tokens
            
            if not context.blueprint and  context.individual and context.cardarea == G.play and (context.other_card:get_id() == 9)  then
                addtokentocosmic(self,1)           
            end
            if context.discard and not context.other_card.debuff and pseudorandom('leo') < self.ability.extra.chance/100 then 
                local card=context.other_card
                if card:get_edition() ~= nil then return nil end
                local edition = poll_edition('leo', nil, true, true)
                shakecard(card)
                card:set_edition(edition)
                return {
                    message = localize('k_c_upgrade'),
                    colour = G.C.PURPLE,
                    card = card
                } 
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chance}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'edition' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicvirgo = {
        name = "Cosmic - Virgo",
        text = {         
            "Decreases blind size by {C:blue}0.1%{} per {C:purple}Cosmic-Token{}",
            "on all your {C:purple}Cosmic Jokers{}. {C:inactive}(Currently {C:blue}#2#%{}{C:inactive} decrease)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}10{} scored.",
			"{C:inactive}(Discerning wisdom guides Virgo's protection.)",
            "{C:inactive}(Total {C:purple}Cosmic-Tokens:{} {X:purple,C:white}#3#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,decrease=5,tokenstotal=0,blindbuffer=0}},
		pos = { x = 8, y = 2 },
        rarity=3,
        cost = 12,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.tokenstotal=countcosmictokens()
            self.ability.extra.decrease=3+(self.ability.extra.tokenstotal*0.1)            
            if self.ability.extra.decrease>70 then --capped at 70% decrease
                self.ability.extra.decrease=70
            end

            if not context.blueprint and  context.individual and context.cardarea == G.play and (context.other_card:get_id() == 10)  then
                addtokentocosmic(self,1)           
            end

            if context.setting_blind then
                self.ability.extra.blindbuffer=G.GAME.blind.chips               
            end

            G.GAME.blind.chips=self.ability.extra.blindbuffer*(1-(self.ability.extra.decrease/100))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.decrease, self.ability.extra.tokenstotal}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'blind_size' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmiclibra = {
        name = "Cosmic - Libra",
        text = {         
            "Adds {C:mult}+1%{} chip value of scored card as Mult",
            "per {C:purple}Cosmic-Token{} on all your {C:purple}Cosmic Jokers{}.",
            "{C:inactive}(Currently {C:mult}#2#%{}{C:inactive} chip value as Mult)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}Jack{} scored.",
			"{C:inactive}(Graceful equilibrium guides Libra's decisions.)",
            "{C:inactive}(Total {C:purple}Cosmic-Tokens:{} {X:purple,C:white}#3#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,chipasmult=20,tokenstotal=0}},
		pos = { x = 9, y = 2 },
        rarity=3,
        cost = 12,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.tokenstotal=countcosmictokens()
            self.ability.extra.chipasmult=20+self.ability.extra.tokenstotal      


            if not context.blueprint and  context.individual and context.cardarea == G.play then
                if (context.other_card:get_id() == 11)  then 
                    addtokentocosmic(self,1)   
                end   
                local cardvalue=math.floor(context.other_card:get_chip_bonus()*(self.ability.extra.chipasmult/100))
                if(cardvalue>0) then
                    return {
                    message = '+'..cardvalue..localize('k_c_mult'),
                    colour=G.C.PURPLE,
                    mult = cardvalue,
                    card = self
                    }  
                end
            end


        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.chipasmult, self.ability.extra.tokenstotal}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'chipvalue' }
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicscorpio = {
        name = "Cosmic - Scorpio",
        text = {                   
            "Scored cards gain {C:chips}+1{} Chips permanently",
            "per {C:purple}Cosmic-Token{} on all your {C:purple}Cosmic Jokers{}.",
            "{C:inactive}(Currently {C:chips}+#2#{}{C:inactive} Chips)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}Queen{} scored.",
			"{C:inactive}(Unyielding determination propels Scorpio's evolution.)",
            "{C:inactive}(Total {C:purple}Cosmic-Tokens:{} {X:purple,C:white}#3#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,bonuschips=3,tokenstotal=0}},
		pos = { x = 10, y = 2 },
        rarity=3,
        cost = 12,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.tokenstotal=countcosmictokens()
            self.ability.extra.bonuschips=3+self.ability.extra.tokenstotal  

            if context.individual and context.cardarea == G.play then
                if not context.blueprint and  (context.other_card:get_id() == 12) then
                    addtokentocosmic(self,1)
                end 
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra.bonuschips
                return {
                    extra = {message = localize('k_c_upgrade'), colour = G.C.PURPLE},
                    colour = G.C.PURPLE,
                    card = context.other_card
                    }                      
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.bonuschips, self.ability.extra.tokenstotal}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicsagittarius = {
        name = "Cosmic - Sagittarius",
        text = {                   
            "Gains {C:mult}+1{} Mult per {C:purple}Cosmic-Token{}",
            "on all your {C:purple}Cosmic Jokers{}. {C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)",
            "{C:purple}+1 Cosmic-Token{} per {C:attention}King{} scored.",
			"{C:inactive}(Boundless optimism guides Sagittarius' adventures.)",
            "{C:inactive}(Total {C:purple}Cosmic-Tokens:{} {X:purple,C:white}#3#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,mult=10,tokenstotal=0}},
		pos = { x = 11, y = 2 },
        rarity=3,
        cost = 12,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.tokenstotal=countcosmictokens()
            self.ability.extra.mult=30+self.ability.extra.tokenstotal  

            if context.individual and context.cardarea == G.play then
                if not context.blueprint and  (context.other_card:get_id() == 13) then
                    addtokentocosmic(self,1)
                end                  
            end
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                    }
                end
            end
        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.mult, self.ability.extra.tokenstotal}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	},
    cosmicophiuchus = {
        name = "Cosmic - Ophiuchus",
        text = {                   
            "Gains {X:mult,C:white}X0.01{} Mult per {C:purple}Cosmic-Token{}",
            "on all your {C:purple}Cosmic Jokers{}. {C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)",
            "{C:purple}Cosmic Jokers{} gain 3X as many {C:purple}Cosmic-Tokens{}.",
			"{C:inactive}(When the stars gather, Ophiuchus shines once more)",
            "{C:inactive}(Total {C:purple}Cosmic-Tokens:{} {X:purple,C:white}#3#{}{C:inactive})"      
		},
		ability = {extra={tokens=0,x_mult=1,tokenstotal=0}},
		pos = { x = 12, y = 2 },
        rarity=4,
        cost = 35,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            self.ability.extra.tokenstotal=countcosmictokens()
            self.ability.extra.x_mult=1+(self.ability.extra.tokenstotal *0.01) 
            if context.other_joker then      
                if context.other_joker == self then
                    return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                    Xmult_mod = self.ability.extra.x_mult
                    }
                end
            end

        end,
        loc_def=function(self)
            return {self.ability.extra.tokens,self.ability.extra.x_mult, self.ability.extra.tokenstotal}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'cosmic_token' }
        end                
	}, 
     omenbrokenmirror = {
        name = "Omen - Broken Mirror",
        text = {                   
            "{C:green}#1# in #2#{} chance to turn", 
            "scored hand into {C:attention}Glass Cards{}.",
            "{C:red}#1# in #3#{} chance to {C:attention}shatter{} after scoring", 
			"{C:inactive}(Mirror, mirror on the wall.)"  
		},
		ability = {extra={positiveodds=6,negativeodds=4}},
		pos = { x = 0, y = 4 },
        rarity=2,
        cost = 8,
        blueprint_compat=true,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if SMODS.end_calculate_context(context) then
                if pseudorandom('brokenmirror') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    trigger_goodkarma(self)
                for i= 1, #context.full_hand do
                    local card=context.full_hand[i]
                    if card.config.center == G.P_CENTERS.c_base then --if card is c_base/without enhancements
                        local enhancement = G.P_CENTERS.m_glass
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('card1', 5);card:juice_up(0.3, 0.3);return true end }))
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('tarot1', 5);card:set_ability(enhancement);return true end }))
                    end
                end
                if pseudorandom('brokenmirror2') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    trigger_badkarma(self)
                    destroyCard(self,glass)
                    if  #G.jokers.cards < G.jokers.config.card_limit then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            play_sound('timpani')                    
                            addjoker('j_omenmirrorshard')
                            self:juice_up(0.3, 0.5)
                            return true end }))
                        delay(0.6)   
                        end
                    end
                end
            end 
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds}
        end,
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'shatter' }
        end                
	},  
    omenmirrorshard= {
        name = "Omen - Mirror Shard",
        text = {
            "When selecting a {C:attention}blind{}:",                   
            "{C:green}#1# in #2#{} chance to turn into",
            "{C:attention}Omen - Broken Mirror{}.{C:inactive}",
            "{C:red}#1# in #3#{} chance to get {C:red}destroyed{}.", 
			"{C:inactive}(... lucky?)"  
		},
		ability = {extra={positiveodds=3,negativeodds=3}},
		pos = { x = 1, y = 4 },
        rarity=1,
        cost = 2,
        blueprint_compat=false,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.setting_blind then
                 if pseudorandom('mirrorshard') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    trigger_goodkarma(self)
                    destroyCard(self,glass)
                    if  #G.jokers.cards < G.jokers.config.card_limit then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            play_sound('timpani')                    
                            addjoker('j_omenbrokenmirror')
                            self:juice_up(0.3, 0.5)
                            return true end }))
                        delay(0.6)   
                        end
                    end
                else if pseudorandom('mirrorshard2') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    trigger_badkarma(self)
                    destroyCard(self,glass)
                end
            end          
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds}
        end,              
	}, 
    omensuspiciousladder= {
        name = "Omen - Suspicious Ladder",
        text = {
            "When selecting a {C:attention}blind{}:",                   
            "{C:green}#1# in #2#{} chance to {C:green}decrease blind size{}.", 
            "{C:red}#1# in #3#{} chance to {C:red}increase blind size{}", 
			"{C:inactive}(It just stands there. Menacingly!)"  
		},
		ability = {extra={positiveodds=6,negativeodds=4}},
		pos = { x = 2, y = 4 },
        rarity=2,
        cost = 8,
        blueprint_compat=false,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.setting_blind then
                local increase=false
                local decrease=false
                if pseudorandom('suspiciousladder') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    increase=true
                end
                if pseudorandom('suspiciousladder2') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    decrease=true
                end
                if decrease==true and increase==true then
                    if pseudorandom('suspiciousladder3')>=0.5 then
                        decrease=false
                    else
                        increase=false
                    end                
                elseif decrease==true then
                    trigger_goodkarma(self)
                    G.GAME.blind.chips=math.ceil(G.GAME.blind.chips*0.8)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                elseif increase==true then
                    trigger_badkarma(self)
                    G.GAME.blind.chips=math.ceil(G.GAME.blind.chips*1.2)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                end
            end          
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds}
        end,   
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'omen_blindsize' }
        end      
	},   
    omenblackcat= {
        name = "Omen - Black Cat",
        text = {                               
            "{C:green}#1# in #2#{} chance to turn", 
            "scored hand into {C:attention}Lucky Cards{}.",
            "{C:red}#1# in #3#{} chance to {C:red}lose {C:money}$2{} after scoring", 
			"{C:inactive}(Why did the cat cross the road?)"  
		},
		ability = {extra={positiveodds=6,negativeodds=4}},
		pos = { x = 4, y = 4 },
        rarity=2,
        cost = 8,
        blueprint_compat=false,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if SMODS.end_calculate_context(context) then
                if pseudorandom('blackcat') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    trigger_goodkarma(self)
                    for i= 1, #context.full_hand do
                        local card=context.full_hand[i]
                        if card.config.center == G.P_CENTERS.c_base then --if card is c_base/without enhancements
                            local enhancement = G.P_CENTERS.m_lucky
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('card1', 5);card:juice_up(0.3, 0.3);return true end }))
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() card:flip();play_sound('tarot1', 5);card:set_ability(enhancement);return true end }))
                        end
                    end
                end
                if pseudorandom('blackcat2') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    trigger_badkarma(self)
                    ease_dollars(-2)
                end
            end
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds}
        end,    
	},  
    omenthirteen= {
        name = "Omen - Thirteen",
        text = {
            "Gains {X:mult,C:white}X0.25{} Mult when {C:red}bad effects{} activate.", 
            "{C:inactive}(Currently: {X:mult,C:white}X#4#{} {C:inactive}Mult)",                              
            "{C:green}#1# in #2#{} chance {C:green}increase {C:red}Bad Karma{}.", 
            "{C:red}#1# in #3#{} chance {C:red}decrease {C:green}Good Karma{}.",
			"{C:inactive}(A lucky number?)"  
		},
		ability = {extra={positiveodds=6,negativeodds=4,x_mult=1}},
		pos = { x = 3, y = 4 },
        rarity=3,
        cost = 12,
        blueprint_compat=false,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker == self then 
                if pseudorandom('thirteen') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    trigger_goodkarma(self)
                    mod_badkarma(-1)         
                end       
                if pseudorandom('thirteen') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    trigger_badkarma(self)
                    mod_goodkarma(1)   
                end
                return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                Xmult_mod = self.ability.extra.x_mult
                }
            end
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds,self.ability.extra.x_mult}
        end,   
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'karma' }
        end   
	},  
    omenseven= {
        name = "Omen - Seven",
        text = {
            "Gains {X:mult,C:white}X0.25X{} Mult when {C:green}good{} effects activate.",
            "{C:inactive}(Currently: {X:mult,C:white}X#4#{} {C:inactive}Mult)",                            
            "{C:green}#1# in #2#{} chance {C:green}increase Good Karma{}.", 
            "{C:red}#1# in #3#{} chance {C:red}decrease {C:green}Good Karma{}.",
			"{C:inactive}(A lucky number!)"  
		},
		ability = {extra={positiveodds=4,negativeodds=6,x_mult=1}},
		pos = { x = 8, y = 4 },
        rarity=3,
        cost = 12,
        blueprint_compat=false,
        eternal_compat=true,
        effect=nil,
        soul_pos=nil,
        calculate = function(self,context)
            if context.other_joker == self then 
                if pseudorandom('seven') < G.GAME.probabilities.normal / self.ability.extra.positiveodds then
                    trigger_goodkarma(self)
                    mod_goodkarma(-1)         
                end       
                if pseudorandom('seven') < G.GAME.probabilities.normal / self.ability.extra.negativeodds then
                    trigger_badkarma(self)
                    mod_goodkarma(1)   
                end
                return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                Xmult_mod = self.ability.extra.x_mult
                }
            end
        end,
        loc_def=function(self)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra.positiveodds,self.ability.extra.negativeodds,self.ability.extra.x_mult}
        end,   
        tooltip=function(self, info_queue)
            info_queue[#info_queue+1] = { set = 'Other', key = 'karma' }
        end   
	},  
}







function SMODS.INIT.ThemedJokers()
    ---localization texts:---
    --OMEN
    G.localization.misc.dictionary.k_o_lucky = "Good Karma!"
    G.localization.misc.dictionary.k_o_unlucky = "Bad Karma!"
    --COSMIC
    G.localization.misc.dictionary.k_c_upgrade = "Cosmic Upgrade!"
    G.localization.misc.dictionary.k_c_dollars = "Cosmic Money!"
    G.localization.misc.dictionary.k_c_seal = "Cosmic Seal!"
    G.localization.misc.dictionary.k_c_token = "Cosmic!"
    G.localization.misc.dictionary.k_c_mult = " Cosmic Mult!"
    --MISCHIEVOUS ONE
    G.localization.misc.dictionary.k_return = "HE RETURNS ONCE MORE!"
    
    
    ---localization tooltips:---
    G.localization.descriptions.Other["karma"] = {
        name = "Karma",
        text = {
            "{C:green}Good Karma{} increases",
            "{C:green}good effect{} odds.",
            "{C:red}Bad Karma{} increases",
            "{C:red}bad effect{} odds."
        }
    }
    
    
    G.localization.descriptions.Other["omen_blindsize"] = {
        name = "Blind Size",
        text = {
            "Modifies {C:attention}Blind Size{} by {C:blue}20%{}.",
            "Chooses randomly, if",
            "both effects would trigger."
        }
    }
    G.localization.descriptions.Other["shatter"] = {
        name = "Shatter",
        text = {
            "When this card shatters,",
            "destroy it. Then",
            "create 1 {C:attention}Omen - Mirror Shard",
            "{C:inactive}(Must have room)"
        }
    }
    G.localization.descriptions.Other["cosmic_token"] = {
        name = "Cosmic-Token",
        text = {
            "{C:purple}Cosmic Jokers{} gain",
            "{X:purple,C:white}Cosmic-Tokens{} to",
            "buff themself or",
            "other jokers."
        }
    }
    G.localization.descriptions.Other["enhancement"] = {
        name = "Enhancement",
        text = {
            "This effect {C:red}can't{} change",
            "the card into a {C:attention}Stone Card"
        }
    }
    G.localization.descriptions.Other["retrigger"] = {
        name = "Retrigger",
        text = {
            "At {C:green}100%+{} chance",
            "+1 guaranteed {C:attention}retrigger{}.",
            "{C:inactive}Capped at 120%"
        }
    }
    G.localization.descriptions.Other["seals"] = {
        name = "Seals",
        text = {
            "This effect includes",
            "vanilla and modded seals.",
            "{C:inactive}Only affects cards",
            "{C:inactive}without a seal."
        }
    }
    G.localization.descriptions.Other["edition"] = {
        name = "Editions",
        text = {
            "Possible editions:",
            "{C:attention}Foil{}, {C:attention}Holographic{}",
            "and {C:attention}Polychrome{}",
            "{C:inactive}Only affects cards",
            "{C:inactive}without a edition."
        }
    }
    G.localization.descriptions.Other["blind_size"] = {
        name = "Blind Size",
        text = {
            "Decreases the",
            "required {C:attention}Chips{} to",
            "beat the blind.",
            "{C:inactive}Capped at 70%"
        }
    }
    G.localization.descriptions.Other["chipvalue"] = {
        name = "Chip Value",
        text = {
            "Card's base chips",
            "+ added bonus chips",
            "{C:inactive}Does not include",
            "{C:inactive}edition bonus chips."
        }
    }
    init_localization()

    --Create and register jokers
    for k, v in pairs(jokers) do
        if not config.vanillaart and string.match(k,'cosmic') then
            v.pos.y=v.pos.y+1
        end
        local joker = SMODS.Joker:new(v.name, k, v.ability, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost, true, true, v.blueprint_compat, v.eternal_compat, v.effect, "ThemedJokers",v.soul_pos)
        -- SMODS.Joker:new(name, slug, config, spritePos, tloc_tx, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat, effect, atlas, soul_pos)
        joker:register()
        --added calculate function into jokers to make code cleaner
        SMODS.Jokers[joker.slug].calculate=v.calculate
        --added loc_def function into jokers to make code cleaner
        SMODS.Jokers[joker.slug].loc_def=v.loc_def
        if(v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip=v.tooltip
        end
    end
    --Create sprite atlas
    SMODS.Sprite:new("ThemedJokers", SMODS.findModByID("ThemedJokers").path, "ThemedJokers.png", 71, 95, "asset_atli"):register()
end	

----------------------------------------------
------------MOD CODE END----------------------
