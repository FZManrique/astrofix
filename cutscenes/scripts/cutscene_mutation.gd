extends Object
class_name CutsceneMutations

const CutsceneManager := preload("res://cutscenes/cutscene_manager.gd")
var cutscene_player: CutsceneManager = null

## Code to run when cutscene initially enters
func _on_start() -> void:
	pass

## Code to run when cutscene image increments
func _on_step(index: int) -> void:
	pass

## Code to run after cutscene ends
func _on_end() -> void:
	pass
