extends Control

@onready var home := $Home as VBoxContainer
@onready var settings := $Settings as VBoxContainer
@onready var master_volume := $Settings/MasterVolume as CheckButton


var music_enabled := true

func _ready() -> void:
	$Home/Start.grab_focus()

func _on_start_pressed() -> void:
	SceneManager.goto_scene("res://scenes/levels/level_1.tscn")

func _on_settings_pressed() -> void:
	home.hide()
	settings.show()
	master_volume.button_pressed = music_enabled
	$Settings/MasterVolume.grab_focus()

func _on_back_pressed() -> void:
	settings.hide()
	home.show()
	$Home/Start.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit() 

func _on_music_pressed() -> void:
	music_enabled = !music_enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !music_enabled)  
