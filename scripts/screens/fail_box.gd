class_name FailBox
extends CanvasLayer

signal on_game_restart

func _ready() -> void:
	get_tree().paused = true
	Music.stop_music()
	%FailSFX.play()

func _on_restart_pressed() -> void:
	on_game_restart.emit()
	get_tree().paused = false
	queue_free()

func _on_exit_pressed() -> void:
	SceneManager.quit_game()
