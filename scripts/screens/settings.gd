extends Control

signal on_settings_show
signal on_settings_hide

func _ready() -> void:
	var displaymode := DisplayServer.window_get_mode()
	$Panel/SettingsList/CheckButton.button_pressed = displaymode == DisplayServer.WINDOW_MODE_FULLSCREEN
	on_settings_show.emit()

func _on_master_slider_changed(value: float) -> void:
	var master_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value / 100))

func _on_music_slider_changed(value: float) -> void:
	var music_index := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value / 100))

func _on_sfx_slider_changed(value: float) -> void:
	var sfx_index := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value / 100))

func _on_check_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_back_pressed() -> void:
	on_settings_hide.emit()
	queue_free()
