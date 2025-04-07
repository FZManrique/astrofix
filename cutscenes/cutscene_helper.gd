extends Control

func _ready() -> void:
	$CenterContainer/PanelContainer/HBoxContainer/Button.pressed.connect(
		func() -> void:
			var text = $CenterContainer/PanelContainer/HBoxContainer/TextEdit.text
	
			DataManager.current_cutscene = load(text)
			SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
	)
