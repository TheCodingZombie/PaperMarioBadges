-- save current paths
mod_dir = ''..SMODS.current_mod.path
--pmb_config = SMODS.current_mod.config     not needed right now, but maybe later

-- ATLASES HERE
SMODS.Atlas { -- All Other Consumables
	-- Key for code to find it with
	key = "PMBadges",
	-- The name of the file, for the code to pull the atlas from
	path = "PMBadges.png",
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


-- loads all badge files for use later
-- might change depending on the needs of this mod as well as potential future ideas
-- like making this more like an API 
local path = SMODS.current_mod.path..'src/'
for _,v in pairs(NFS.getDirectoryItems(path)) do
    assert(SMODS.load_file('src/'..v))()
end

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
            if card.seal and card.seal == 'pmb_goldmedal' and (card.config.center.discovered or card.bypass_discovery_center) then
                card.children.center:draw_shader('pmb_gold', nil, card.ARGS.send_to_shader)
                if card.children.front and (card.ability.delayed or (card.ability.effect ~= 'Stone Card' and not card.config.center.replace_base_card)) then
                    card.children.front:draw_shader('pmb_gold', nil, card.ARGS.send_to_shader)
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