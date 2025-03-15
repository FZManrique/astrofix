extends Label

func _ready() -> void:
	text = GoalManager.current_goal
	
	GoalManager.connect(
		"on_goals_changed",
		_on_goals_changed
	)

func _on_goals_changed() -> void:
	text = GoalManager.current_goal
