class_name Minigame
extends CanvasLayer

signal on_dismiss

func _ready() -> void:
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	on_dismiss.emit()
	queue_free()
