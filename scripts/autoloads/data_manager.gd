# A place to store constants and other related information

extends Node

# TODO Remove
signal Level4_has_done_confrontation

enum WIND_DIRECTION {TO_TOP, TO_LEFT, TO_BOTTOM, TO_RIGHT}

var should_quit := false
var can_pause := false

var show_instruction_box := false
var intro_done := false

var current_cutscene: CutsceneResource = null
var in_cutscene = false

var Level1 := {
	has_hit_spikes = false,
	has_key = false,
	has_fuel = false,
	should_move_william_to_ship = false,
	william_moved_to_ship = false,
}

var Level2 := {
	in_starting_area = false,
	has_fixed_spacesuit = false,
	is_minigame = false,
	many_fuel_collected = false,
	fuel_collected = false,
	wind_push = false,
	wind_direction = WIND_DIRECTION.TO_TOP,
	wind_speed = 100,
}

var Level3 := {
	talked_once_to_chloe = false,
	asked_for_help = false,
	finished_intro = false,
	collected_cover = false,
	in_asteroid_area = false,
}

var Level4 := {
	crystal_count = 0,
	talked_to_conny = false,
	talked_after_most_crystals = false,
	done_confrontation = false,
	in_minigame = false,
}
