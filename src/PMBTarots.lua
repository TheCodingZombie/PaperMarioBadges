local appliers = {}

local seals = SMODS.Seals

a = {}
for n in pairs(seals) do table.insert(a, n) end
table.sort(a)

for i,n in ipairs(a) do
    local k = n
    local v = seals[n]
    if v.badge then -- check if the seal wants to be a badg
        local item = {
            key = k.."_applier",
            set = "badge_appliers",
            atlas = v.cns_atlas or v.atlas,
            pos = v.cns_pos or v.pos,
            cost = 3,
            loc_txt = {
                ['default'] = {
                    name = "Badge Applier",
                    text = {
                        "Applies {C:attention}#1#{} to the",
                        "selected or leftmost Joker",
                    },
                },
            },
            config = {generated = k},
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_SEALS[self.config.generated]
                return { vars = { G.localization.descriptions.Other[self.config.generated.."_seal"].name } }
            end,
            can_use = function(self, card)
                if not G.jokers.highlighted or #G.jokers.highlighted ~= 1 then
                    return G.jokers and G.jokers.cards and #G.jokers.cards > 1 and G.jokers.cards[1]
                elseif card.ability.generated.unique and next(pmb_find_joker_with_seal(card.ability.generated)) then
                    return false
                else
                    return true
                end
            end,
            use = function(self, card, area, copier)
                play_sound('tarot1')
                card:juice_up()
                if not G.jokers.highlighted or #G.jokers.highlighted ~= 1 then
                    if G.jokers and G.jokers.cards and G.jokers.cards[1] then
                        G.jokers.cards[1]:set_seal(card.ability.generated)
                    end
                else
                   G.jokers.highlighted[1]:set_seal(card.ability.generated)
                end
            end,
            in_pool = (v.in_pool and type(v.in_pool) == 'function') or function(self, args)
                if self.config.generated.unique and next(pmb_find_joker_with_seal(self.config.generated)) then return false
                else return true end
            end
        }
        appliers[#appliers+1] = item
    end
end

return {
    name = "BadgeAppliersBase",
    list = appliers
}