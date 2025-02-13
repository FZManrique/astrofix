extends Control

@onready var home := $Home as VBoxContainer
@onready var help := $Help as VBoxContainer
@onready var start := $Home/Start as Button

@export var settings_scene: PackedScene

func _ready() -> void:
	Music.play_music("res://audio/music/main_menu.wav")

func _on_start_pressed() -> void:
	SceneManager.goto_scene("res://scenes/cutscene/cutscene.tscn")

func _on_settings_pressed() -> void:
	add_child(settings_scene.instantiate())

func _on_help_pressed() -> void:
	home.hide()
	help.show()

func _on_back_pressed() -> void:
	help.hide()
	home.show()
	start.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit() 
