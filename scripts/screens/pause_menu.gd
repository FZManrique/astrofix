extends Control

@export var settings_scene: PackedScene

var allow_unpause: bool = false

func _ready() -> void:
	if OS.has_feature('web'):
		$ColorRect/VBoxContainer/VBoxContainer/Quit.visible = false
	
	SceneManager.on_game_paused.connect(
		_on_game_paused
	)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_pause") && allow_unpause):
		allow_unpause = false
		hide()
		get_tree().paused = false

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_settings_pressed() -> void:
	var instance := settings_scene.instantiate()
	instance.connect("on_settings_show", func() -> void: $ColorRect.hide())
	instance.connect("on_settings_hide", func() -> void: $ColorRect.show())
	add_child(instance)

func _on_main_menu_pressed() -> void:
	SceneManager.goto_scene("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_game_paused() -> void:
	show()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	allow_unpause = true
