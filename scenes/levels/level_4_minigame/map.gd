extends CanvasLayer

var is_shown = false

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("map")):
		if (is_shown):
			get_tree().paused = false
			is_shown = false
			hide()
		else:
			get_tree().paused = true
			is_shown = true
			show()
