# A place to store constants and other related information

extends Node

enum WIND_DIRECTION {TO_TOP, TO_LEFT, TO_BOTTOM, TO_RIGHT}

var should_quit := false
var can_pause := false
var show_instruction_box := false
var intro_done := false

var Cutscene := {
	current_cutscene_number = 1,
	is_end_mode = false
}

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
	wind_push = false,
	wind_direction = WIND_DIRECTION.TO_TOP,
	wind_speed = 100
}
