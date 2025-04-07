-- All or Nothing
SMODS.Seal{
    key = 'allornothing',
    atlas = 'PMBadges',
    pos = {x = 0, y = 0},
    config = {extra = {odds = 4, xmult = 2.0, seal_disabled = false}},
    badge_colour = HEX('ff0000'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        if context.before and pseudorandom('AON') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
           card:set_debuff(true)
           card.ability.seal.extra.seal_disabled = true
           card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_disabled_ex'),colour = G.C.MULT, delay = 0.45})
        end

        if context.final_scoring_step and card.ability.seal.extra.seal_disabled then
            card:set_debuff(false)
            card.ability.seal.extra.seal_disabled = false
        end
        if context.joker_main and not card.debuff then
            return {
                xmult = card.ability.seal.extra.xmult,
                card = card
            }
        end
    end
}

-- ATTACK FXS HERE

-- Bump Attack
SMODS.Seal{
    key = 'bumpattack',
    atlas = 'PMBadges',
    pos = {x = 5, y = 0},
    config = {extra = {last_score = 0}},
    badge_colour = HEX('1092a5'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.seal.extra.last_score} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return to_big(card.ability.seal.extra.last_score) > to_big(G.GAME.blind.chips) and not G.RESET_JIGGLES end
                juice_card_until(self, eval, true)
            end
        end

        if context.setting_blind and to_big(card.ability.seal.extra.last_score) > to_big(G.GAME.blind.chips) then
            G.GAME.chips = math.floor(to_big(G.GAME.blind.chips) / 2)
            G.GAME.chip_text = number_format(G.GAME.chips)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_scored'), colour = G.C.ATTENTION, delay = 0.45})
        end

        if context.end_of_round then
            card.ability.seal.extra.last_score = to_big(G.GAME.chips)
        end
    end
}

-- Charge
SMODS.Seal{
    key = 'charge',
    atlas = 'PMBadges',
    pos = {x = 6, y = 0},
    config = {extra = {activated = false, xmult = 3}},
    badge_colour = HEX('1092a5'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return card.ability.seal.extra.activated and not G.RESET_JIGGLES end
                juice_card_until(self, eval, true)
            end
        end

        if context.setting_blind and card.ability.seal.extra.activated then
            card:set_debuff(true)
        end

        if context.end_of_round then
            if card.ability.seal.extra.activated then card.ability.seal.extra.activated = true
            else card.ability.seal = nil end
        end

        if context.post_joker then
            return {
                xmult = card.ability.seal.extra.xmult,
                card = card,
            }
        end
    end
}

-- Chill Out
SMODS.Seal{
    key = 'chillout',
    atlas = 'PMBadges',
    pos = {x = 7, y = 0},
    config = {extra = {}},
    badge_colour = HEX('ffdb00'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)

        -- Boss Blind disable
        if context.setting_blind and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
        end

        -- saving on the first hand
        if G.GAME.current_round.hands_played == 0 and G.GAME.current_round.hands_left == 0 then
            ease_hands_played(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_saved_ex"), colour = G.C.FILTER, delay = 0.45})
        end
    end
}

-- Close Call
SMODS.Seal{
    key = 'closecall',
    atlas = 'PMBadges',
    pos = {x = 8, y = 0},
    config = {extra = {odds = 5}},
    badge_colour = HEX('ff6900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            if to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.5) and context.game_over and pseudorandom('cc') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        return true
                    end
                })) 
                return {
                    message = localize('k_saved_ex'),
                    saved = true,
                    colour = G.C.RED
                }
            end
        end
    end
}

-- Damage Dodge
SMODS.Seal{
    key = 'damagedodge',
    atlas = 'PMBadges',
    pos = {x = 0, y = 1},
    config = {extra = {odds = 2}},
    badge_colour = HEX('b54594'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
           if string.find(context.scoring_name, "High Card") and pseudorandom('dd') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_hands_played(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("pmb_nice"), colour = G.C.BLUE, delay = 0.45})
           end
        end
    end
}

-- Defense Plus
SMODS.Seal{
    key = 'defenseplus',
    atlas = 'PMBadges',
    pos = {x = 1, y = 1},
    config = {extra = {odds = 4}},
    badge_colour = HEX('6396d6'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
           if pseudorandom('dp') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_hands_played(1)
           end
        end
    end
}

-- Double Dip
SMODS.Seal{
    key = 'doubledip',
    atlas = 'PMBadges',
    pos = {x = 2, y = 1},
    config = {extra = {odds = 3}},
    badge_colour = HEX('ce4531'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable and not context.consumeable.edition and pseudorandom('ddip') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    key = context.consumeable.config.center.key
                }
                local _card = SMODS.add_card(t)
                _card:set_edition('e_negative')
                SMODS.Stickers.pm_monochrome:apply(_card, nil)
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("pmb_copyadded"), colour = G.C.SECONDARY_SET.Tarot, delay = 0.45})
            end
        end 
    end
}

-- Double Pain
SMODS.Seal{
    key = 'doublepain',
    atlas = 'PMBadges',
    pos = {x = 3, y = 1},
    config = {extra = {}},
    badge_colour = HEX('ce4531'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.blind.chips = G.GAME.blind.chips * 2
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("pmb_pain"), colour = G.C.RED, delay = 0.45})
        end
    end
}

-- Feeling Fine
SMODS.Seal{
    key = 'feelingfine',
    atlas = 'PMBadges',
    pos = {x = 4, y = 1},
    config = {extra = {}},
    badge_colour = HEX('ff9a00'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.perishable then v.ability.perishable = nil end
                if v.ability.rental then v.ability.rental = nil end
                if v.ability['pm_monochrome'] then SMODS.Stickers.pm_monochrome:apply(card, nil) end
            end
        end
    end
}

-- Fire Drive
SMODS.Seal{
    key = 'firedrive',
    atlas = 'PMBadges',
    pos = {x = 5, y = 1},
    config = {extra = {}},
    badge_colour = HEX('ff7900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_blazehammer
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_blazehammer'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- First Attack
SMODS.Seal{
    key = 'firstattack',
    atlas = 'PMBadges',
    pos = {x = 6, y = 1},
    config = {extra = {last_score = 0, xmult = 5}},
    badge_colour = HEX('008200'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.seal.extra.last_score, self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return to_big(card.ability.seal.extra.last_score) > to_big(G.GAME.blind.chips) and not G.RESET_JIGGLES end
                juice_card_until(self, eval, true)
            end
        end

        if context.joker_main and to_big(card.ability.seal.extra.last_score) > to_big(G.GAME.blind.chips) then
            return {
                xmult = card.ability.seal.extra.xmult,
                card = card,
            }
        end

        if context.end_of_round then
            card.ability.seal.extra.last_score = to_big(G.GAME.chips)
        end
    end
}

-- Flower Finder
SMODS.Seal{
    key = 'flowerfinder',
    atlas = 'PMBadges',
    pos = {x = 7, y = 1},
    config = {extra = {odds = 5, charged = false}},
    badge_colour = HEX('bde7e6'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and pseudorandom('flower') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            card.ability.seal.extra.charged = true
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_ffound'), colour = G.C.ATTENTION, delay = 0.45})
        end
        if context.first_hand_drawn and card.ability.seal.extra.charged then
            ease_discard(1)
            card.ability.seal.extra.charged = false
        end
    end
}

-- FP Saver
SMODS.Seal{
    key = 'flowersaver',
    atlas = 'PMBadges',
    pos = {x = 8, y = 1},
    config = {extra = {odds = 4}},
    badge_colour = HEX('ffff8c'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.discard and pseudorandom('flower') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_discard(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_fsaved'), colour = G.C.ATTENTION, delay = 0.45})
        end
    end
}

-- FP Drain
SMODS.Seal{
    key = 'flowerdrain',
    atlas = 'PMBadges',
    pos = {x = 0, y = 2},
    config = {extra = {odds = 3}},
    badge_colour = HEX('ff7900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.before and pseudorandom('flower') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_discard(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_fdrain'), colour = G.C.ATTENTION, delay = 0.45})
        end
    end
}

-- Flower Plus
SMODS.Seal{
    key = 'flowerplus',
    atlas = 'PMBadges',
    pos = {x = 1, y = 2},
    config = {extra = {}},
    badge_colour = HEX('ff7900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            ease_discard(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Discard", colour = G.C.RED, delay = 0.45})
        end
	end,
	remove_from_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            ease_discard(-1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-1 Discard", colour = G.C.RED, delay = 0.45})
        end
	end
}

-- Gold Medal
SMODS.Seal{
    key = 'goldmedal',
    atlas = 'PMBadges',
    pos = {x = 2, y = 2},
    config = {extra = {}},
    badge_colour = SMODS.Gradients.pmb_golden,
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

-- Hammer Throw
SMODS.Seal{
    key = 'hammerthrow',
    atlas = 'PMBadges',
    pos = {x = 3, y = 2},
    config = {extra = {odds = 3}},
    badge_colour = HEX('ce7900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_hurlhammer
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('hurl') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_hurlhammer'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- HAMMERMAN TODO

-- Happy Flower
SMODS.Seal{
    key = 'happyflower',
    atlas = 'PMBadges',
    pos = {x = 5, y = 2},
    config = {extra = {hands = 3}},
    badge_colour = HEX('107110'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.seal.extra.hands} }
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            if card.ability.seal.extra.hands == 1 then
                card.ability.seal.extra.hands = 3
                ease_discard(1)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Discard", colour = G.C.RED, delay = 0.45})
            else
                card.ability.seal.extra.hands = card.ability.seal.extra.hands - 1
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.seal.extra.hands.." Remaining", colour = G.C.BLUE, delay = 0.45})
            end
        end
    end
}

-- Happy Heart
SMODS.Seal{
    key = 'happyheart',
    atlas = 'PMBadges',
    pos = {x = 6, y = 2},
    config = {extra = {discards = 3}},
    badge_colour = HEX('107110'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.seal.extra.discards} }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and context.cardarea == G.jokers then
            if card.ability.seal.extra.discards == 1 then
                card.ability.seal.extra.discards = 3
                ease_hands_played(1)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Hand", colour = G.C.BLUE, delay = 0.45})
            else
                card.ability.seal.extra.discards = card.ability.seal.extra.discards - 1
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.seal.extra.discards.." Remaining", colour = G.C.RED, delay = 0.45})
            end
        end
    end
}

-- Head Rattle
SMODS.Seal{
    key = 'headrattle',
    atlas = 'PMBadges',
    pos = {x = 7, y = 2},
    config = {extra = {odds = 4}},
    badge_colour = HEX('6b498c'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        -- Boss Blind disable
        if context.joker_main and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled and pseudorandom('head') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            G.GAME.blind:disable()
            play_sound('timpani')
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
        end
    end
}

-- Heart Finder
SMODS.Seal{
    key = 'heartfinder',
    atlas = 'PMBadges',
    pos = {x = 8, y = 2},
    config = {extra = {odds = 5, charged = false}},
    badge_colour = HEX('ff9896'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and pseudorandom('heart') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            card.ability.seal.extra.charged = true
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_hfound'), colour = G.C.ATTENTION, delay = 0.45})
        end
        if context.first_hand_drawn and card.ability.seal.extra.charged then
            ease_hands_played(1)
            card.ability.seal.extra.charged = false
        end
    end
}

-- HP Drain
SMODS.Seal{
    key = 'heartdrain',
    atlas = 'PMBadges',
    pos = {x = 0, y = 3},
    config = {extra = {odds = 4}},
    badge_colour = HEX('ffb2b5'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.before and pseudorandom('heart') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_hands_played(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_hdrain'), colour = G.C.ATTENTION, delay = 0.45})
        end
    end
}

-- HP Plus
SMODS.Seal{
    key = 'heartplus',
    atlas = 'PMBadges',
    pos = {x = 1, y = 3},
    config = {extra = {}},
    badge_colour = HEX('b52421'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            ease_hands_played(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Hand", colour = G.C.BLUE, delay = 0.45})
        end
	end,
	remove_from_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            ease_hands_played(-1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-1 Hand", colour = G.C.BLUE, delay = 0.45})
        end
	end
}

-- Ice Power
SMODS.Seal{
    key = 'icepower',
    atlas = 'PMBadges',
    pos = {x = 2, y = 3},
    config = {extra = {}},
    badge_colour = HEX('a5cece'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end
}

-- Ice Smash
SMODS.Seal{
    key = 'icesmash',
    atlas = 'PMBadges',
    pos = {x = 3, y = 3},
    config = {extra = {odds = 2}},
    badge_colour = HEX('a5cece'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_iceflower
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('ice') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_iceflower'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Item Hog
SMODS.Seal{
    key = 'itemfinder',
    atlas = 'PMBadges',
    pos = {x = 4, y = 3},
    config = {extra = {odds = 5, charged = false}},
    badge_colour = HEX('ff7919'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds, (pm_config and pm_config.bc_rarity > 1) and localize("pmb_battle_card") or localize("pmb_tarot")} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and pseudorandom('item') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            if #G.consumeables.cards < G.consumeables.config.card_limit then
                local t = {}
                if pm_config and pm_config.bc_rarity > 1 then
                    t = {
                        set = 'pm_BattleCard'
                    }
                else
                    t = {
                        set = 'Tarot'
                    }
                end
                SMODS.add_card(t) 

                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_ifound'), colour = G.C.SECONDARY_SET.Tarot, delay = 0.45})
            end
        end
    end
}

-- JUMPMAN TODO

-- L EMBLEM TODO

-- Last Stand
SMODS.Seal{
    key = 'laststand',
    atlas = 'PMBadges',
    pos = {x = 7, y = 3},
    config = {extra = {odds = 2}},
    badge_colour = HEX('ff6900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if G.GAME.current_round.hands_left <= 1 and not context.blueprint then
            local eval = function() return to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.5) and not G.RESET_JIGGLES end
            juice_card_until(self, eval, true)
        end

        if context.before and not context.blueprint then
            if G.GAME.current_round.hands_left <= 1 and to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.5) and pseudorandom('ls') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                ease_hands_played(1)
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("pmb_nice"), colour = G.C.BLUE, delay = 0.45})
            end
        end
    end
}

-- Lucky Day
SMODS.Seal{
    key = 'luckyday',
    atlas = 'PMBadges',
    pos = {x = 8, y = 3},
    config = {extra = {odds = 7}},
    badge_colour = HEX('005100'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over and pseudorandom('lucky') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        return true
                    end
                })) 
                return {
                    message = localize('pmb_lucky'),
                    saved = true,
                    colour = G.C.GREEN
                }
        end
    end
}

-- Lucky Start
SMODS.Seal{
    key = 'luckystart',
    atlas = 'PMBadges',
    pos = {x = 0, y = 4},
    config = {extra = {}},
    badge_colour = HEX('9c1c19'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local other_joker = pseudorandom_element(G.P_SEALS, pseudoseed('lucky'))

            if other_joker and other_joker ~= self and not context.no_blueprint then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or self
                local other_joker_ret = other_joker:calculate_seal(context)
                context.blueprint = nil
                context.blueprint_card = nil
                if other_joker_ret then 
                    other_joker_ret.card = card
                    other_joker_ret.colour = G.C.BLUE
                    return other_joker_ret
                end
            end
        end
    end
}

-- Mega Rush
SMODS.Seal{
    key = 'megarush',
    atlas = 'PMBadges',
    pos = {x = 1, y = 4},
    config = {extra = {xmult = 5}},
    badge_colour = HEX('ff6900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if G.GAME.current_round.hands_left <= 1 and not context.blueprint then
            local eval = function() return to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.25) and not G.RESET_JIGGLES end
            juice_card_until(self, eval, true)
        end

        if context.joker_main then
            if G.GAME.current_round.hands_left == 0 and to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.25) then
                return {
                    xmult = card.ability.seal.extra.xmult,
                    card = card
                }
            end
        end
    end
}

-- Money Money
SMODS.Seal{
    key = 'moneyfinder',
    atlas = 'PMBadges',
    pos = {x = 2, y = 4},
    config = {extra = {money = 2}},
    badge_colour = HEX('ff7919'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.money} }
    end,
    calculate_dollar_bonus = function()
        return card.ability.seal.extra.money
    end
}

-- Multibounce
SMODS.Seal{
    key = 'multibounce',
    atlas = 'PMBadges',
    pos = {x = 3, y = 4},
    config = {extra = {odds = 3}},
    badge_colour = HEX('3a9e3a'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_linejump
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('multi') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_linejump'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- NOSTALGIC TUNES TODO

-- P-Down, D-Up
SMODS.Seal{
    key = 'pdowndup',
    atlas = 'PMBadges',
    pos = {x = 5, y = 4},
    config = {extra = {xmult = 0.9, xchips = 1.1}},
    badge_colour = HEX('527f52'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult, self.config.extra.xchips} }
    end,
    calculate = function(self, card, context)
        if joker_main then
            return {
                xmult = card.ability.seal.extra.xmult,
                xchips = card.ability.seal.extra.xchips,
                card = card
            }
        end
    end
}

-- PEEKABOO TODO

-- Piercing Blow
SMODS.Seal{
    key = 'piercingblow',
    atlas = 'PMBadges',
    pos = {x = 7, y = 4},
    config = {extra = {odds = 5}},
    badge_colour = HEX('7bc2de'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_eekhammer
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('piercing') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_eekhammer'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Pity Flower
SMODS.Seal{
    key = 'pityflower',
    atlas = 'PMBadges',
    pos = {x = 8, y = 4},
    config = {extra = {odds = 2}},
    badge_colour = HEX('422d5a'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step and not context.end_of_round and pseudorandom('pity') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_discard(1)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('pmb_fpity'), colour = G.C.ATTENTION, delay = 0.45})
        end
    end
}

-- Power Bounce
SMODS.Seal{
    key = 'powerbounce',
    atlas = 'PMBadges',
    pos = {x = 0, y = 5},
    config = {extra = {odds = 4}},
    badge_colour = HEX('31659c'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_hopslipper
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('hop') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_hopslipper'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Power Jump
SMODS.Seal{
    key = 'powerjump',
    atlas = 'PMBadges',
    pos = {x = 1, y = 5},
    config = {extra = {odds = 3}},
    badge_colour = HEX('636163'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_ironjump
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('powerjump') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_ironjump'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Power Plus
SMODS.Seal{
    key = 'powerplus',
    atlas = 'PMBadges',
    pos = {x = 2, y = 5},
    config = {extra = {xmult = 1.25}},
    badge_colour = HEX('ce4531'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        if joker_main then
            return {
                xmult = card.ability.seal.extra.xmult,
                card = card
            }
        end
    end
}

-- Power Rush
SMODS.Seal{
    key = 'powerrush',
    atlas = 'PMBadges',
    pos = {x = 3, y = 5},
    config = {extra = {xmult = 2}},
    badge_colour = HEX('ff6900'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        -- shake while ability active
        if G.GAME.current_round.hands_left <= 1 and not context.blueprint then
            local eval = function() return to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.5) and not G.RESET_JIGGLES end
            juice_card_until(self, eval, true)
        end

        if context.joker_main then
            if G.GAME.current_round.hands_left <= 1 and to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 0.5) then
                return {
                    xmult = card.ability.seal.extra.xmult,
                    card = card
                }
            end
        end
    end
}

-- Power Smash
SMODS.Seal{
    key = 'powersmash',
    atlas = 'PMBadges',
    pos = {x = 4, y = 5},
    config = {extra = {odds = 9}},
    badge_colour = HEX('636163'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_kohammer
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('powersmash') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_kohammer'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Pretty Lucky
SMODS.Seal{
    key = 'prettylucky',
    atlas = 'PMBadges',
    pos = {x = 5, y = 5},
    config = {extra = {odds = 6}},
    badge_colour = HEX('184979'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over and pseudorandom('lucky') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        return true
                    end
                })) 
                return {
                    message = localize('pmb_lucky'),
                    saved = true,
                    colour = G.C.GREEN
                }
        end
    end
}

-- P-Up, D-Down
SMODS.Seal{
    key = 'pupddown',
    atlas = 'PMBadges',
    pos = {x = 6, y = 5},
    config = {extra = {xmult = 1.1, xchips = 0.9}},
    badge_colour = HEX('d66563'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult, self.config.extra.xchips} }
    end,
    calculate = function(self, card, context)
        if joker_main then
            return {
                xmult = card.ability.seal.extra.xmult,
                xchips = card.ability.seal.extra.xchips,
                card = card
            }
        end
    end
}

-- Refund
SMODS.Seal{
    key = 'refund',
    atlas = 'PMBadges',
    pos = {x = 0, y = 6},
    config = {extra = {}},
    badge_colour = HEX('ce4531'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and G.GAME.blind.in_blind then
            if context.consumeable then
                ease_dollars(context.consumable.sell_cost)
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..context.consumable.sell_cost, colour = G.C.MONEY, delay = 0.45})
            end
        end 
    end
}

-- Return Postage
SMODS.Seal{
    key = 'returnpostage',
    atlas = 'PMBadges',
    pos = {x = 1, y = 6},
    config = {extra = {chips = 100, mult = 15}},
    badge_colour = HEX('ad92ce'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.chips, self.config.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.debuff then
                return {
                    chips = card.ability.seal.extra.chips,
                    card = context.other_card
                }
            end
        end
        if context.other_joker then
            if context.other_joker.debuff then
                return{
                    mult = card.ability.seal.extra.mult,
                    card = context.other_joker
                }
            end
        end
    end
}

-- Shrink Stomp
SMODS.Seal{
    key = 'shrinkstomp',
    atlas = 'PMBadges',
    pos = {x = 2, y = 6},
    config = {extra = {odds = 4}},
    badge_colour = HEX('e692c5'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds,} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('shrink') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                G.GAME.blind.chips = G.GAME.blind.chips * 0.75
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            end
        end
    end
}

-- Simplifier
SMODS.Seal{
    key = 'simplifier',
    atlas = 'PMBadges',
    pos = {x = 3, y = 6},
    config = {extra = {money = -1}},
    badge_colour = HEX('8cce8c'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.money * -1} }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.seal.extra.money
    end
}

-- Sleep Stomp
SMODS.Seal{
    key = 'sleepstomp',
    atlas = 'PMBadges',
    pos = {x = 4, y = 6},
    config = {extra = {odds = 4, turns_left = 0, cur_hands = 0}},
    badge_colour = HEX('ffce63'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.turns_left} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and card.ability.seal.extra.turns_left > 0 then
            card.ability.seal.extra.cur_hands = G.GAME.current_round.hands_left
        end

        if context.joker_main then
            if pseudorandom('sleep') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) and card.ability.seal.extra.turns_left == 0 then
                card.ability.seal.extra.turns_left = 3
                card.ability.seal.extra.cur_hands = G.GAME.current_round.hands_left
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_sleep'), colour = G.C.GREEN})
            else
                if card.ability.seal.extra.turns_left > 1 then
                    card.ability.seal.extra.turns_left = card.ability.seal.extra.turns_left - 1
                    card_eval_status_text(_card, 'extra', nil, nil, nil, {message = card.ability.seal.extra.turns_left.." Turns Remaining", colour = G.C.GREEN})
                else
                    card.ability.seal.extra.turns_left = 0
                    card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_done'), colour = G.C.RED})
                end
                card:juice_up()
                if G.GAME.current_round.hands_left < card.ability.seal.extra.cur_hands then ease_hands_played(1) end
            end
        end
    end
}

-- SLOW GO TODO

-- Soft Stomp
SMODS.Seal{
    key = 'softstomp',
    atlas = 'PMBadges',
    pos = {x = 6, y = 6},
    config = {extra = {odds = 4, exponent = 1.25}},
    badge_colour = HEX('e692c5'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.exponent} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('soft') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local m = to_big(mult)
                local milt = to_number(m ^ (card.ability.seal.extra.exponent - 1))
                return {
                    xmult = milt,
                    remove_default_message  = true,
                    message = localize("pmb_exponential"), 
                    colour = G.C.SECONDARY_SET.Tarot,
                    card = card
                }
            end
        end
    end
}

-- Spike Shield TODO
SMODS.Seal{
    key = 'spikeshield',
    atlas = 'PMBadges',
    pos = {x = 7, y = 6},
    config = {extra = {}},
    badge_colour = HEX('52ce52'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        
    end
}

-- Super Appeal
SMODS.Seal{
    key = 'superappeal',
    atlas = 'PMBadges',
    pos = {x = 8, y = 6},
    config = {extra = {money = 3}},
    badge_colour = HEX('ffbe00'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.money,} }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
           if string.find(context.scoring_name, "High Card") and pseudorandom('dd') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
            ease_dollars(3)
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("pmb_appeal"), colour = G.C.ATTENTION, delay = 0.45})
           end
        end
    end
}

-- Timing Tutor
SMODS.Seal{
    key = 'timingtutor',
    atlas = 'PMBadges',
    pos = {x = 0, y = 7},
    config = {extra = {highlighted = {}}},
    badge_colour = HEX('ff6d00'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

-- Tornado Jump
SMODS.Seal{
    key = 'tornadojump',
    atlas = 'PMBadges',
    pos = {x = 1, y = 7},
    config = {extra = {odds = 5}},
    badge_colour = HEX('ff6d00'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    dependencies = {
        "PMCS",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_pm_spinjump
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if #G.consumeables.cards < G.consumeables.config.card_limit and pseudorandom('tornado') < (G.GAME.probabilities.normal / card.ability.seal.extra.odds) then
                local t = {
                    area = G.consumeables,
                    key = 'c_pm_spinjump'
                }
                SMODS.add_card(t)
                card:juice_up()
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('pmb_plus_battlecard'), colour = G.C.PURPLE})
            end
        end
    end
}

-- Unsimplifier
SMODS.Seal{
    key = 'unsimplifier',
    atlas = 'PMBadges',
    pos = {x = 2, y = 7},
    config = {extra = {money = 1}},
    badge_colour = HEX('ad8ece'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.money} }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.seal.extra.money
    end
}

-- W EMBLEM TODO

-- Zap Tap
SMODS.Seal{
    key = 'zaptap',
    atlas = 'PMBadges',
    pos = {x = 4, y = 7},
    config = {extra = {xmult = 1.1}},
    badge_colour = HEX('ad92ce'),
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.debuff then
                return {
                    xmult = card.ability.seal.extra.xmult,
                    card = context.other_card
                }
            end
        end
        if context.other_joker then
            if context.other_joker.debuff then
                return{
                    xmult = card.ability.seal.extra.xmult,
                    card = context.other_joker
                }
            end
        end
    end
}