
/// 3 x 3 damage centred on the xenomorph
/datum/action/xeno_action/onclick/rend
	name = "Rend"
	action_icon_state = "crest_defense"
	ability_name = "rend"
	macro_path = /datum/action_xeno_action/verb/verb_rend
	xeno_cooldown = 2.5 SECONDS
	plasma cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/damage = 25

/// Charge ability
/datum/action/xeno_action/activable/pounce/unstoppable_force
	name = "Unstoppable Force"
	action_icon_state = "crest_defense"
	ability_name = "unstoppable_force"
	macro_path = /datum/action_xeno_action/verb/unstoppable_force
	xeno_cooldown = 2.5 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_2

	throw_speed = SPEED_VERY_FAST

	windup = TRUE
	windup_duration = 2 SECONDS
	windup_interruptable = TRUE

	tracks_target = FALSE
	can_be_shield_blocked = FALSE
	knockdown = 2 SECONDS

	///Dealt to all mobs adjacent when the charge ends.
	var/end_charge_damage = 50
	///Additonally dealt to any mob directly hit by the charge.
	var/direct_hit_damage = 50
	///Distance to throw carbons directly hit
	var/throw_distance = 5


/// Screech which puts out lights in a 7 tile radius, slows and dazes.
/datum/action/xeno_action/activable/doom
	name = "Doom"
	action_icon_state = "crest_defense"
	ability_name = "doom"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 2.5 SECONDS
	plasma cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/daze_length_seconds = 1
	var/slow_length_seconds = 2

/// Leap ability, crashing down dealing major damage to mobs and structures in the area.
/datum/action/xeno_action/activable/destroy
	name = "Destroy"
	action_icon_state = "crest_defense"
	ability_name = "destroy"
	macro_path = /datum/action/xeno_action/verb/verb_destroy
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_4

	var/leaping = FALSE