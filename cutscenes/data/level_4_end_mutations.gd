extends CutsceneMutations

func _on_step(index: int) -> void:
	pass

func _on_end() -> void:
	SceneManager.goto_scene("res://scenes/levels/level_5.tscn")
