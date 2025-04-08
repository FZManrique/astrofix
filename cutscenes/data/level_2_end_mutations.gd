extends CutsceneMutations

func _on_end() -> void:
	DataManager.current_cutscene = preload("res://cutscenes/data/level_3.tres")
	SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
