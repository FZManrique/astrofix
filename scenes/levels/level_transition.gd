extends CanvasLayer

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	SceneManager.goto_scene("res://scenes/cutscene/cutscene.tscn")
