extends Control

signal on_settings_show
signal on_settings_hide

var master_index := AudioServer.get_bus_index("Master")
var music_index := AudioServer.get_bus_index("Music")
var sfx_index := AudioServer.get_bus_index("SFX")

func _ready() -> void:
	var displaymode := DisplayServer.window_get_mode()
	$Panel/SettingsList/CheckButton.set_pressed_no_signal(displaymode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	$Panel/SettingsList/Sliders/MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(master_index)) * 100
	$Panel/SettingsList/Sliders/MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index)) * 100
	$Panel/SettingsList/Sliders/SfxSlider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index)) * 100

	on_settings_show.emit()

func _on_master_slider_changed(value: float) -> void:
	var master_db_value := linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(master_index, master_db_value)

func _on_music_slider_changed(value: float) -> void:
	var music_db_value := linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(music_index, music_db_value)

func _on_sfx_slider_changed(value: float) -> void:
	var sfx_db_value := linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(sfx_index, sfx_db_value)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_back_pressed() -> void:
	on_settings_hide.emit()
	queue_free()
