extends Node

var GOALS := [
	# LEVEL 1
	"Find a fuel tank",
	"Explore the area to find a key",
	"Unlock the fuel tank",
	"Go to the ship to refuel it",
	# Level 2
	"Explore the area to find fuel"
]

signal on_goals_changed
signal on_goals_cleared

var _goal_empty := false

var _current_index := 0
var current_goal: String:
	get:
		if (_goal_empty): return ""
		return GOALS[_current_index]
	set(value):
		# ignore
		pass

func go_to_next_goal(index: int) -> void:
	_current_index = index
	on_goals_changed.emit()

func clear_goals() -> void:
	_goal_empty = true
	on_goals_cleared.emit()
