extends CutsceneMutations

func _on_step(index: int) -> void:
	pass

func _on_end() -> void:
	DataManager.current_cutscene = load("res://cutscenes/data/level_4.tres")
	SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
