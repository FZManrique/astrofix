extends Control


func _on_start_pressed() -> void:
	Globals.goto_scene("res://scenes/level_1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit() 
