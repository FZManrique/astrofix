extends RichTextLabel

signal on_goal_changed
var unformatted_text: String

@onready var timer: Timer = $Timer

func clear_goals() -> void:
	text = ""

func change_goal(string: String) -> void:
	on_goal_changed.emit()
	unformatted_text = "Goal: " + string
	timer.start()
	text = "[pulse freq=1.0 color=#ddddddff ease=-2.0]" + unformatted_text + "[/pulse]"

func _on_timer_timeout() -> void:
	text = unformatted_text
