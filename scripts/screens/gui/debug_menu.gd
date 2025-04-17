extends HBoxContainer

@onready var text_edit: TextEdit = $TextEdit

func _ready() -> void:
	hide()
	
	$Navigate.pressed.connect(
		func() -> void:
			get_tree().paused = false
			SceneManager.goto_scene(text_edit.text)
			hide()
	)
	$Quit.pressed.connect(
		func() -> void:
			get_tree().paused = false
			GameStateManager.quit_game()
	)
	$Cancel.pressed.connect(
		func() -> void:
			get_tree().paused = false
			hide()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_console"):
		get_tree().paused = true
		show()
