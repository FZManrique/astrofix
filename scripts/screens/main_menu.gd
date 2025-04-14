extends Control

@onready var home := $Home as VBoxContainer
@onready var help := $Help as VBoxContainer
@onready var start := $Home/Start as Button

@export var settings_scene: PackedScene


func _ready() -> void:
	$AnimationPlayer.play("vignette")
	Music.play_music("res://audio/music/main_menu.wav")


func _on_start_pressed() -> void:
	DataManager.current_cutscene = preload("res://cutscenes/data/level_1.tres")
	SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")


func _on_settings_pressed() -> void:
	print("Settings pressed")
	add_child(settings_scene.instantiate())


func _on_help_pressed() -> void:
	home.hide()
	help.show()


func _on_back_pressed() -> void:
	help.hide()
	home.show()
	start.grab_focus()


func _on_quit_pressed() -> void:
	SceneManager.quit_game()
