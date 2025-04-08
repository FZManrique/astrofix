extends CutsceneMutations

func _on_end() -> void:
	DataManager.current_cutscene = preload("res://cutscenes/data/level_5.tres")
	SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
