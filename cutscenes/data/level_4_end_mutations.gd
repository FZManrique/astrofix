extends CutsceneMutations

func _on_step(index: int) -> void:
	pass

func _on_end() -> void:
	SceneManager.quit_game()
