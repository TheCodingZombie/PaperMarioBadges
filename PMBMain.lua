-- save current paths
mod_dir = ''..SMODS.current_mod.path
--pmb_config = SMODS.current_mod.config     not needed right now, but maybe later

-- Talisman --
to_big = to_big or function(num)
    return num
end

-- Return an array of all (non-debuffed) jokers with a certain seal (key)
-- Debuffed jokers count if `count_debuffed` is true.
function pmb_find_joker_with_seal(key, count_debuffed)
    local results = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        for _, v in pairs(area.cards) do
            if v and type(v) == 'table' and v.seal and v.seal == key and (count_debuffed or not v.debuff) then
                table.insert(results, v)
            end
        end
    end
    return results
end

-- ATLASES HERE
SMODS.Atlas { -- All Badges
	-- Key for code to find it with
	key = "PMBadges",
	-- The name of the file, for the code to pull the atlas from
	path = "PMBadges.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas { -- All Appliers
	-- Key for code to find it with
	key = "PMAppliers",
	-- The name of the file, for the code to pull the atlas from
	path = "PMAppliers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

-- add the gold shader, from the SMODS examples
SMODS.Shader{
	key = "gold",
	path = "gold.fs",
}

-- add a highlighting shader, credits to Cryptid for the astral shader that i just yoinked and made yellow asf
SMODS.Shader{
	key = "highlighted",
	path = "highlighted.fs",
}

-- add a gradient specifically for the gold medal lmao
SMODS.Gradient{
	key = "golden",
	colours = {
		HEX("ebd234"),
		HEX("dec109"),
		HEX("f5e162"),
		HEX("d6b627"),
	},
	cycle = 3,
}

SMODS.ConsumableType{
	key = 'badge_appliers',
	primary_colour = HEX("a83c32"),
	secondary_colour =HEX("a83c32"),
	collection_rows = {6, 6, 6},
	shop_rate = 0.75,
	loc_txt = { 
        name = 'Badge Applier', -- used on card type badges
        collection = 'Badge Appliers', -- label for the button to access the collection
    },
}

-- loads all badge files for use later
local loaded = assert(SMODS.load_file('src/PMBadges.lua'))()
-- Then load everything in the custom folder
local files = NFS.getDirectoryItemsInfo(mod_dir .. "/custom/")
for i = 1, #files do
	local file_name = files[i].name
	if file_name:sub(-4) == ".lua" then
		assert(SMODS.load_file("custom/" .. file_name))()
	end
end

if not loaded then
	-- automagically making consumables that apply badges
	local consumable, load_error = assert(SMODS.load_file("src/PMBTarots.lua"))
	if load_error then
		sendDebugMessage ("The error is: "..load_error)
	else
		local curr_consumable = consumable()
		if curr_consumable.init then curr_consumable:init() end
		for i, item in ipairs(curr_consumable.list) do
			item.discovered = true
			SMODS.Consumable(item)
		end
	end
end

SMODS.Sound({
    key = 'music_64battle',
    path = '64battle.ogg',
    pitch = 1,
    volume = 0.2,
    sync = {},
    select_music_track = function()
		local has_nostalgic_tunes = false
		if G.GAME and G.GAME.blind and G.GAME.blind.in_blind then
			if G.jokers and G.jokers.cards then
				for i=1, #G.jokers.cards do
					if G.jokers.cards[i].seal and G.jokers.cards[i].seal == 'pmb_nostalgictunes' then has_nostalgic_tunes = true; break end
            	end
			end
		end
        return loaded and G.GAME and G.GAME.blind and G.GAME.blind.in_blind and has_nostalgic_tunes
    end
})

-- make retriggers exist
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true
    }
end

-- makes the gold medal work
SMODS.DrawStep {
    key = 'gold_step',
    order = -1,
    conditions = {
        facing = 'front',
    },
    func = function (card, layer)
        if layer == 'card' or layer == 'both' then
            if ((card.seal and card.seal == 'pmb_goldmedal') or (card.ability and card.ability.seal and card.ability.seal.extra and type(card.ability.seal.extra) == "table" and card.ability.seal.extra.other_joker and card.ability.seal.extra.other_joker.seal and card.ability.seal.extra.other_joker.seal == 'pmb_goldmedal')) and (card.config.center.discovered or card.bypass_discovery_center) then
                card.children.center:draw_shader('pmb_gold', nil, card.ARGS.send_to_shader)
                if card.children.front and (card.ability.delayed or (card.ability.effect ~= 'Stone Card' and not card.config.center.replace_base_card)) then
                    card.children.front:draw_shader('pmb_gold', nil, card.ARGS.send_to_shader)
                end
            end
        end
    end,
}

-- draw the badge that lucky start is copying
SMODS.DrawStep {
    key = 'lucky_step',
    order = 66,
    conditions = {
        facing = 'front',
    },
    func = function (card, layer)
        if layer == 'card' or layer == 'both' then
            if card.seal and card.seal == 'pmb_luckystart' and card.ability and card.ability.seal and card.ability.seal.extra and type(card.ability.seal.extra) == "table" and card.ability.seal.extra.other_joker and card.ability.seal.extra.other_joker.seal and (card.config.center.discovered or card.bypass_discovery_center) then
                card.children.lucky_step = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["pmb_PMBadges"], card.ability.seal.extra.other_joker.ability.seal.pos)
            else
                card.children.lucky_step = nil
            end
        end
    end,
}

-- makes timing tutor work

SMODS.DrawStep {
	key = 'highlighting',
	order = 10,
	conditions = {
        facing = 'front',
    },
	func = function (card, layer)
		local found = nil
		if G.STAGE == G.STAGES.RUN and G.jokers and G.jokers.cards then
			for i=1, #G.jokers.cards do
				if G.jokers.cards[i].seal and G.jokers.cards[i].seal == 'pmb_timingtutor' then found = G.jokers.cards[i]; break end
			end
		end

        if layer == 'card' or layer == 'both' then
            if card.playing_card and found and (card.config.center.discovered or card.bypass_discovery_center) then
				local highlighting = find_best_hand(G.hand.cards, 5)

				for i=1, #highlighting do
					local _card = highlighting[i]
					if _card == card and not (G.play and G.play.cards and in_array(G.play.cards, card)) then
						_card.children.center:draw_shader('pmb_highlighted', nil, card.ARGS.send_to_shader)
						if _card.children.front and (_card.ability.delayed or (_card.ability.effect ~= 'Stone Card' and not _card.config.center.replace_base_card)) then
							_card.children.front:draw_shader('pmb_highlighted', nil, _card.ARGS.send_to_shader)
						end
						return
					end
				end
            end
        end
    end,
}

-- deal with Simplifier and Unsimplifier
local ec = eval_card
function eval_card(card, context)
	-- Store old probability for later reference
	local ggpn = G.GAME.probabilities.normal
	if card.seal == 'pm_simplifier_seal' then
		G.GAME.probabilities.normal = G.GAME.probabilities.normal + 1
	elseif card.seal == 'pm_unsimplifier_seal' then
		G.GAME.probabilities.normal = G.GAME.probabilities.normal - 1
	end
	local ret, post = ec(card, context)
	if card.seal == 'pm_simplifier_seal' or card.seal == 'pm_unsimplifier_seal' then
		G.GAME.probabilities.normal = ggpn
	end
	return ret, post
end

-- Literally just for timing tutor lmao
function find_suit_from_flush(hand)
	local suits = SMODS.Suit.obj_buffer
	local nuits = {}

	for j = 1, #suits do
		local suit = suits[j]
		local flush_count = 0
		for i=1, #hand do
			if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1 end 
		end
		nuits[suit] = flush_count
	end

	table.sort(suits, function(a, b) return nuits[a] > nuits[b] end)

	return suits[1], nuits[suits[1]]
end

-- why do this? because there's legit no function that does it lmao
function find_full_house_from_hand(hand)
	local ranks = SMODS.Rank.obj_buffer
	local nanks = {}
	
	for j = 1, #ranks do
		local rank = ranks[j]
		local rank_count = 0
		for i=1, #hand do
			if hand[i]:get_id() == rank then rank_count = rank_count + 1 end 
		end
		nanks[rank] = rank_count
	end

	table.sort(ranks, function(a, b) return nanks[a] > nanks[b] end)
	local rank1 = nil
	local rank2 = nil
	for i=1, #ranks do
		if not rank1 and nanks[ranks[i]] >= 3 then rank1 = ranks[i]
		elseif not rank2 and ranks[i] ~= rank1 and nanks[ranks[i]] >= 2 then rank2 = ranks[i]; break end
	end

	return rank1, rank2
end

function find_best_hand(hand, size_limit)
	local poker_hands = evaluate_poker_hand(hand)
	local scoring_hand = {}
	local best_hand = {}
	local text = "NULL"
    if next(poker_hands["Flush Five"]) then text = "Flush Five"; scoring_hand = poker_hands["Flush Five"][1]
    elseif next(poker_hands["Flush House"]) then text = "Flush House"; scoring_hand = poker_hands["Flush House"][1]
    elseif next(poker_hands["Five of a Kind"]) then text = "Five of a Kind"; scoring_hand = poker_hands["Five of a Kind"][1]
    elseif next(poker_hands["Straight Flush"]) then text = "Straight Flush"; scoring_hand = poker_hands["Straight Flush"][1]
    elseif next(poker_hands["Four of a Kind"]) then text = "Four of a Kind"; scoring_hand = poker_hands["Four of a Kind"][1]
    elseif next(poker_hands["Full House"]) then text = "Full House"; scoring_hand = poker_hands["Full House"][1]
    elseif next(poker_hands["Flush"]) then text = "Flush"; scoring_hand = poker_hands["Flush"][1]
    elseif next(poker_hands["Straight"]) then text = "Straight"; scoring_hand = poker_hands["Straight"][1]
    elseif next(poker_hands["Three of a Kind"]) then text = "Three of a Kind"; scoring_hand = poker_hands["Three of a Kind"][1]
    elseif next(poker_hands["Two Pair"]) then text = "Two Pair"; scoring_hand = poker_hands["Two Pair"][1]
    elseif next(poker_hands["Pair"]) then text = "Pair"; scoring_hand = poker_hands["Pair"][1]
    elseif next(poker_hands["High Card"]) then text = "High Card"; scoring_hand = poker_hands["High Card"][1] end

	if size_limit >= 5 then
		if string.find(text, "Two Pair") or string.find(text, "Four of a Kind") then size_limit = 4
		elseif string.find(text, "Three of a Kind") then size_limit = 3
		elseif string.find(text, "Pair") then size_limit = 2 end
	end
	
	if string.find(text, "House") then
		local h = poker_hands["Full House"][1]
		local s, cnt = find_suit_from_flush(h)
		local t = {}
		local n = {}
		local tree, twei = find_full_house_from_hand(h)
		table.sort(h, function(a, b) return a:get_id() > b:get_id() end)
		if tree and twei then -- we won't take into account any jokers that reduce the flush count
			for i=1, #h do
				if h[i]:is_suit(s) then t[#t+1] = h[i]; end
			end
			for i=1, #t do
				if t[i]:get_id() == rank1 then n[#n+1] = t[i] end
			end
			for i=1, #t do
				if t[i]:get_id() == rank2 then n[#n+1] = t[i] end
			end
			for i=1, size_limit do
				if n[i] then best_hand[#best_hand+1] = n[i] end
			end
		else
			for i=1, size_limit do
				if h[i] then best_hand[#best_hand+1] = h[i] end
			end
		end
	elseif string.find(text, "Flush") then
		local s, cnt = find_suit_from_flush(scoring_hand)
		local t = {}
		for i=1, #scoring_hand do
			if scoring_hand[i]:is_suit(s) then t[#t+1] = scoring_hand[i] end
		end
		table.sort(t, function(a, b) return a:get_id() > b:get_id() end)
		for i=1, size_limit do
			if t[i] then best_hand[#best_hand+1] = t[i] end
		end
	else
		table.sort(scoring_hand, function(a, b) return a:get_id() > b:get_id() end)
		for i=1, size_limit do
			if scoring_hand[i] then best_hand[#best_hand+1] = scoring_hand[i] end
		end
	end
	
	return best_hand
end

function in_array(haystack, needle)
	for i=1, #haystack do
		if haystack[i] == needle then return true end
	end
	return false
end