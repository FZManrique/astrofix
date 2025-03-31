extends Node

var GOALS := [
	# LEVEL 1
	"Find a fuel tank",
	"Explore the area to find a key",
	"Unlock the fuel tank",
	"Go to the ship to refuel it",
	# Level 2
	"Find the ship",
	"Explore the area to find fuel",
	"Refuel the ship",
	# Level 3
	"Find a cover to fix the leak",
	"Fix the leak in the ship",
	# Level 4
	"Locate the crystal tower",
	"Find 4 crystal shards to repair the tower",
	"Fix the crystal tower",
	"Look for the missing shard",
	# Level 5
	"Find fuel tanks",
	"Defeat Dan"
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
