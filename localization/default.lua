return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={},
        Joker={},
        Other={
            pmb_allornothing_seal = {
                name = "All or Nothing",
                text = {
                    "{C:green}#1# in #2#{} chance to do nothing.",
                    "{X:mult,C:white}X#3#{} Mult",
                }
            },

            pmb_bumpattack_seal = {
                name = "Bump Attack",
                text = {
                    "If your previous score was greater than the required",
                    "score of the next Blind, {C:attention}instantly{} score {C:mult}half{} of the",
                    "{C:attention}required score{} for this Blind",
                    "{C:inactive}(Cannot stack){}",
                }
            },

            pmb_charge_seal = {
                name = "Charge",
                text = {
                    "When applied, this Joker will get {C:mult}debuffed{}", 
                    "for a round and give {X:mult,C:white}X#1#{} Mult on the next round",
                    "This badge {C:mult}self destructs{} after",
                }
            },

            pmb_chillout_seal = {
                name = "Chill Out",
                text = {
                    "{C:mult}Disable{} the Boss Blind",
                    "You cannot lose on the {C:attention}first hand{}", 
                    "of the round",
                }
            },

            pmb_closecall_seal = {
                name = "Close Call",
                text = {
                    "On the last hand, if your score",
                    "is <= {C:attention}50%{} of the required score,",
                    "{C:green}#1# in #2#{} chance to save you from death",
                }
            },

            pmb_damagedodge_seal = {
                name = "Damage Dodge",
                text = {
                    "{C:green}#1# in #2#{} chance to not",
                    "use a {C:blue}hand{} when playing a {C:attention}High Card{}",
                }
            },

            pmb_defenseplus_seal = {
                name = "Defense Plus",
                text = {
                    "{C:green}#1# in #2#{} chance to not",
                    "use a {C:blue}hand{} when playing a hand",
                }
            },

            pmb_doubledip_seal = {
                name = "Double Dip",
                text = {
                    "{C:green}#1# in #2#{} chance to make a",
                    "{C:dark_edition}Negative{} copy of a",
                    "non-{C:dark_edition}Negative{} consumable",
                }
            },

            pmb_doublepain_seal = {
                name = "Double Pain",
                text = {
                    "{C:mult}Doubles{} the score requirement",
                    "of the current Blind at the start of the Blind",
                }
            },

            pmb_feelingfine_seal = {
                name = "Feeling Fine",
                text = {
                    "Jokers cannot be {C:red}debuffed{}",
                    "Jokers can't be affected by {C:dark_edition}Drained{},",
                    "{C:dark_edition}Perishable,{} and {C:money}Rental{}",
                }
            },

            pmb_firedrive_seal = {
                name = "Fire Drive",
                text = {
                    "Gain a {C:attention}Hurlhammer{}",
                    "at the start of the round",
                }
            },

            pmb_firstattack_seal = {
                name = "First Attack",
                text = {
                    "If your previous score was greater than the required",
                    "score of the next Blind, gain {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}(Cannot stack){}",
                }
            },

            pmb_flowerfinder_seal = {
                name = "Flower Finder",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "an extra {C:red}discard{} at the end of a round",
                }
            },

            pmb_flowersaver_seal = {
                name = "Flower Saver",
                text = {
                    "{C:green}#1# in #2#{} chance to not",
                    "use a {C:mult}discard{} when discarding cards",
                }
            },

            pmb_flowerdrain_seal = {
                name = "FP Drain",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "a {C:mult}discard{} when playing a hand",
                }
            },

            pmb_flowerplus_seal = {
                name = "FP Plus",
                text = {
                    "{C:red}+1{} discard",
                }
            },

            pmb_goldmedal_seal = {
                name = "Gold Medal",
                text = {
                    "Adds a {C:gold}golden{} shine",
                }
            },
            
            pmb_hammerthrow_seal = {
                name = "Hammer Throw",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "a {C:attention}Hurlhammer{} at the start of the round",
                }
            },

            pmb_hammerman_seal = {
                name = "Hammerman",
                text = {
                    "All {C:attention}Hammer{} cards cost {C:money}$1{} less,",
                    "but all {C:attention}Jump{} cards are debuffed",
                }
            },

            pmb_happyflower_seal = {
                name = "Happy Flower",
                text = {
                    "Gain {C:mult}+1{} discard",
                    "every {C:chips}#1#{} hands",
                }
            },

            pmb_happyheart_seal = {
                name = "Happy Heart",
                text = {
                    "Gain {C:chips}+1{} hand",
                    "every {C:mult}#1#{} discards",
                }
            },

            pmb_headrattle_seal = {
                name = "Head Rattle",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "{C:mult}disable{} the Boss Blind",
                }
            },

            pmb_heartfinder_seal = {
                name = "Heart Finder",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "an extra {C:blue}hand{} at the end of a round",
                }
            },

            pmb_heartdrain_seal = {
                name = "HP Drain",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "a {C:blue}hand{} when playing a hand",
                }
            },

            pmb_heartplus_seal = {
                name = "HP Plus",
                text = {
                    "{C:blue}+1{} hand",
                }
            },

            pmb_icepower_seal = {
                name = "Ice Power",
                text = {
                    "This Joker cannot be {C:red}destroyed{}",
                }
            },

            pmb_icesmash_seal = {
                name = "Ice Smash",
                text = {
                    "{C:green}#1# in #2#{} chance to gain an",
                    "{C:attention}Ice Flower{} at the start of the round",
                }
            },

            pmb_itemfinder_seal = {
                name = "Item Hog",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "a random {C:purple}#3#{} at the end of a round",
                }
            },

            pmb_jumpman_seal = {
                name = "Jumpman",
                text = {
                    "All {C:attention}Jump{} cards cost {C:money}$1{} less,",
                    "but all {C:attention}Hammer{} cards are debuffed",
                }
            },

            pmb_laststand_seal = {
                name = "Last Stand",
                text = {
                    "On the last {C:attention}2{} hands, if your score",
                    "is <= {C:attention}50%{} of the required score,",
                    "{C:green}#1# in #2#{} chance to not use up hands",
                }
            },

            pmb_luckyday_seal = {
                name = "Lucky Day",
                text = {
                    "{C:green}#1# in #2#{} chance", 
                    "to save you from death",
                }
            },

            pmb_luckystart_seal = {
                name = "Lucky Start",
                text = {
                    "This's Badge's ability becomes",
                    "a {C:green}random{} Badge's ability",
                    "at the start of a round",
                    "{C:inactive}(Chooses from your other non-Lucky Start Badges){}",
                }
            },

            pmb_megarush_seal = {
                name = "Mega Rush",
                text = {
                    "On the last hand, if your score",
                    "is <= {C:attention}25%{} of the required score,",
                    "gain {X:mult,C:white}X#1#{} Mult",
                }
            },

            pmb_moneyfinder_seal = {
                name = "Money Money",
                text = {
                    "Gain {C:money}$#1#{} at",
                    "the end of the round",
                }
            },

            pmb_multibounce_seal = {
                name = "Multibounce",
                text = {
                    "{C:green}#1# in #2#{} chance to gain a",
                    "{C:attention}Line Jump{} at the start of the round",
                }
            },
            
            pmb_pdowndup_seal = {
                name = "P-Down D-Up",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{X:chips,C:white}X#2#{} Chips",
                }
            },

            pmb_peekaboo_seal = {
                name = "Peekaboo",
                text = {
                    "Predicts the score of the",
                    "{C:attention}selected hand",
                    "{C:inactive,s:0.9}(Does not count scoring Jokers... YET){}",
                }
            },

            pmb_piercingblow_seal = {
                name = "Piercing Blow",
                text = {
                    "{C:attention}Playing cards{} cannot be {C:red}debuffed",
                    "{C:green}#1# in #2#{} chance to gain an",
                    "{C:attention}Eekhammer{} at the start of the round",
                }
            },

            pmb_pityflower_seal = {
                name = "Pity Flower",
                text = {
                    "{C:green}#1# in #2#{} chance to gain",
                    "a {C:mult}discard{} when playing a hand",
                    "that doesn't win the round",
                }
            },

            pmb_powerbounce_seal = {
                name = "Power Bounce",
                text = {
                    "{C:green}#1# in #2#{} chance to gain a",
                    "{C:attention}Hopslipper{} at the start of the round",
                }
            },

            pmb_powerjump_seal = {
                name = "Power Jump",
                text = {
                    "{C:green}#1# in #2#{} chance to gain an",
                    "{C:attention}Iron Jump{} at the start of the round",
                }
            },

            pmb_powerplus_seal = {
                name = "Power Plus",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                }
            },

            pmb_powerrush_seal = {
                name = "Power Rush",
                text = {
                    "On the last {C:attention}2{} hands, if your score",
                    "is <= {C:attention}50%{} of the required score,",
                    "gain {X:mult,C:white}X#1#{} Mult",
                }
            },

            pmb_powersmash_seal = {
                name = "Power Smash",
                text = {
                    "{C:green}#1# in #2#{} chance to gain a",
                    "{C:attention}KO Hammer{} at the start of the round",
                }
            },

            pmb_prettylucky_seal = {
                name = "Pretty Lucky",
                text = {
                    "{C:green}#1# in #2#{} chance", 
                    "to save you from death",
                }
            },

            pmb_pupddown_seal = {
                name = "P-Up D-Down",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{X:chips,C:white}X#2#{} Chips",
                }
            },

            pmb_refund_seal = {
                name = "Refund",
                text = {
                    "When using a consumable in a Blind,",
                    "gain {C:money}${} equal to the card's sell value",
                }
            },

            pmb_returnpostage_seal = {
                name = "Return Postage",
                text = {
                    "Debuffed playing cards give {C:chips}+#1#{} Chips",
                    "Debuffed Jokers give {C:mult}+#2#{} Mult",
                }
            },

            pmb_shrinkstomp_seal = {
                name = "Shrink Stomp",
                text = {
                    "{C:green}#1# in #2#{} chance to reduce",
                    "the blind score requirement by {C:attention}25%{}",
                    "whenever this Joker {C:attention}triggers{}",
                }
            },

            pmb_simplifier_seal = {
                name = "Simplifier",
                text = {
                    "Increases listed probabilities",
                    "of this card by {C:green}1{}",
                    "but reduces money gained at", 
                    "end of round by {C:money}$#1#{}",
                }
            },

            pmb_sleepstomp_seal = {
                name = "Sleep Stomp",
                text = {
                    "{C:green}#1# in #2#{} chance to apply",
                    "{C:attention}Sleep{}, which stops hand use",
                    "for {C:attention}#3#{} hands",
                }
            },

            pmb_slowgo_seal = {
                name = "Slow Go",
                text = {
                    "Slows down the game by {C:attention}50%{}",
                }
            },
            
            pmb_softstomp_seal = {
                name = "Soft Stomp",
                text = {
                    "{C:green}#1# in #2#{} chance to increase",
                    "score by {X:dark_edition,C:white}^#3#{}",
                }
            },

            pmb_spikeshield_seal = {
                name = "Spike Shield",
                text = {
                    "{C:blue}Hands{} are not lost when playing",
                    "a hand containing a {C:red}debuffed{} card",
                }
            },

            pmb_superappeal_seal = {
                name = "Super Appeal",
                text = {
                    "Gain {C:money}$#1#{} when you play",
                    "a {C:attention}High Card{}",
                }
            },

            pmb_timingtutor_seal = {
                name = "Timing Tutor",
                text = {
                    "{C:attention}Highlights{} the best hand playable",
                    "{C:inactive,s:0.9}(Goes in poker hand order)",
                }
            },

            pmb_tornadojump_seal = {
                name = "Tornado Jump",
                text = {
                    "{C:green}#1# in #2#{} chance to gain an",
                    "{C:attention}Spin Jump{} at the start of the round",
                }
            },

            pmb_unsimplifier_seal = {
                name = "Unsimplifier",
                text = {
                    "Decreases listed probabilities", 
                    "of this card by {C:green}1{}",
                    "but increases money gained", 
                    "at end of round by {C:money}$#1#{}",
                }
            },

            pmb_zaptap_seal = {
                name = "Zap Tap",
                text = {
                    "Debuffed cards give {X:mult,C:white}X#1#{} Mult",
                }
            },
        },
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={},
        pmb_badge_appliers = {
            
        },
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            pmb_scored = "Bumped!",
            pmb_ffound = "Flower Found!",
            pmb_hfound = "Heart Found!",
            pmb_ifound = "Item Found!",
            pmb_fsaved = "Flower Saved!",
            pmb_hsaved = "Heart Saved!",
            pmb_fdrain = "Flower Drained!",
            pmb_hdrain = "Heart Drained!",
            pmb_fpity = "Pity!",
            pmb_pain = "Double Pain!",
            pmb_copyadded = "+1 Copy",
            pmb_nice = "NICE!",
            pmb_lucky = "LUCKY!",
            pmb_appeal = "STYLISH!",
            pmb_blocked = "GUARD!",
            pmb_blocked_ex = "SUPERGUARD!",

            pmb_exponential = "^1,25",
            pmb_plus_battlecard = "+1 Battle Card",
            pmb_done = "Done!",
            pmb_sleep = "Slept!",

            pmb_battle_card = "Battle Card",
            pmb_tarot = "Tarot Card",
        },
        high_scores={},
        labels={
            pmb_allornothing_seal = "All or Nothing",
            pmb_bumpattack_seal = "Bump Attack",
            pmb_charge_seal = "Charge",
            pmb_chillout_seal = "Chill Out",
            pmb_closecall_seal = "Close Call",
            pmb_damagedodge_seal = "Damage Dodge",
            pmb_defenseplus_seal = "Defense Plus",
            pmb_doubledip_seal = "Double Dip",
            pmb_doublepain_seal = "Double Pain",
            pmb_feelingfine_seal = "Feeling Fine",
            pmb_firedrive_seal = "Fire Drive",
            pmb_firstattack_seal = "First Attack",
            pmb_flowerfinder_seal = "Flower Finder",
            pmb_flowersaver_seal = "Flower Saver",
            pmb_flowerdrain_seal = "FP Drain",
            pmb_flowerplus_seal = "FP Plus",
            pmb_goldmedal_seal = "Gold Medal",
            pmb_hammerthrow_seal = "Hammer Throw",
            pmb_hammerman_seal = "Hammerman",
            pmb_happyflower_seal = "Happy Flower",
            pmb_happyheart_seal = "Happy Heart",
            pmb_headrattle_seal = "Head Rattle",
            pmb_heartfinder_seal = "Heart Finder",
            pmb_heartdrain_seal = "HP Drain",
            pmb_heartplus_seal = "HP Plus",
            pmb_icepower_seal = "Ice Power",
            pmb_icesmash_seal = "Ice Smash",
            pmb_itemfinder_seal = "Item Hog",
            pmb_jumpman_seal = "Jumpman",
            pmb_laststand_seal = "Last Stand",
            pmb_luckyday_seal = "Lucky Day",
            pmb_luckystart_seal = "Lucky Start",
            pmb_megarush_seal = "Mega Rush",
            pmb_moneyfinder_seal = "Money Money",
            pmb_multibounce_seal = "Multibounce",
            pmb_pdowndup_seal = "P-Down D-Up",
            pmb_peekaboo_seal = "Peekaboo",
            pmb_piercingblow_seal = "Piercing Blow",
            pmb_pityflower_seal = "Pity Flower",
            pmb_powerbounce_seal = "Power Bounce",
            pmb_powerjump_seal = "Power Jump",
            pmb_powerplus_seal = "Power Plus",
            pmb_powerrush_seal = "Power Rush",
            pmb_powersmash_seal = "Power Smash",
            pmb_prettylucky_seal = "Pretty Lucky",
            pmb_pupddown_seal = "P-Up D-Down",
            pmb_refund_seal = "Refund",
            pmb_returnpostage_seal = "Return Postage",
            pmb_shrinkstomp_seal = "Shrink Stomp",
            pmb_simplifier_seal = "Simplifier",
            pmb_sleepstomp_seal = "Sleep Stomp",
            pmb_slowgo_seal = "Slow Go",
            pmb_softstomp_seal = "Soft Stomp",
            pmb_spikeshield_seal = "Spike Shield",
            pmb_superappeal_seal = "Super Appeal",
            pmb_timingtutor_seal = "Timing Tutor",
            pmb_tornadojump_seal = "Tornado Jump",
            pmb_unsimplifier_seal = "Unsimplifier",
            pmb_zaptap_seal = "Zap Tap",
        },
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}