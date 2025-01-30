extends Control

@onready var home := $Home as VBoxContainer
@onready var settings := $Settings as VBoxContainer
@onready var help := $Help as VBoxContainer

func _ready() -> void:
	Music.play_music("res://soundtrack/music/main_menu.wav")
	$Home/Start.grab_focus()

func _on_start_pressed() -> void:
	SceneManager.goto_scene("res://scenes/levels/level_1.tscn")

func _on_settings_pressed() -> void:
	home.hide()
	help.hide()
	settings.show()

func _on_help_pressed() -> void:
	home.hide()
	settings.hide()
	help.show()

func _on_back_pressed() -> void:
	settings.hide()
	help.hide()
	home.show()
	$Home/Start.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit() 

func _on_master_slider_changed(value: float) -> void:
	var music_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value / 100))

func _on_music_slider_changed(value: float) -> void:
	var music_index := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value / 100))
