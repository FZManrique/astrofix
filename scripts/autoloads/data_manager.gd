# A place to store constants and other related information

extends Node

enum WIND_DIRECTION {TOP, LEFT, BOTTOM, RIGHT}

var Cutscene := {
	cutscene_mode = false,
	current_cutscene_number = 1,
}

var Level1 := {
	has_key = false,
	has_fuel = false,
	should_move_william_to_ship = false,
	william_moved_to_ship = false,
}

var Level2 := {
	wind_push = false,
	wind_direction = WIND_DIRECTION.TOP
}
