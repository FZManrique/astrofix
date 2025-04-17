extends CanvasLayer

var is_shown = false

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("map")):
		if (is_shown):
			GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "level_4_map")
			PauseManager.remove_whitelist(self)
			is_shown = false
			hide()
		else:
			GameStateManager.add_pause_reason(GameStateManager.PauseType.SYSTEM, "level_4_map")
			PauseManager.add_whitelist(self)
			is_shown = true
			show()
