extends CanvasLayer

signal on_game_restart

func _ready() -> void:
	%FailSFX.play()
	Music.stop_music()
	GameStateManager.add_pause_reason(GameStateManager.PauseType.SYSTEM, "fail_box")
	PauseManager.add_whitelist(self)

func _on_restart_pressed() -> void:
	on_game_restart.emit()
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "fail_box")
	PauseManager.remove_whitelist(self)
	queue_free()

func _on_exit_pressed() -> void:
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "fail_box")
	PauseManager.remove_whitelist(self)
	queue_free()
	GameStateManager.complete_level()
	SaveManager.clear_level(GameStateManager.current_level.level_id)
	SceneManager.goto_scene("res://scenes/main.tscn")
	
