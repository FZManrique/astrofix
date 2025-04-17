extends Control

signal on_settings_show
signal on_settings_hide

@onready var check_button: CheckButton = $Panel/SettingsList/CheckButton
@onready var master_slider: HSlider = $Panel/SettingsList/Sliders/MasterSlider
@onready var music_slider: HSlider = $Panel/SettingsList/Sliders/MusicSlider
@onready var sfx_slider: HSlider = $Panel/SettingsList/Sliders/SfxSlider

func _ready() -> void:
	check_button.set_pressed_no_signal(Settings.fullscreen_enabled)
	
	master_slider.value = db_to_linear(Settings.audio_settings.master_db_value) * 100
	music_slider.value = db_to_linear(Settings.audio_settings.music_db_value) * 100
	sfx_slider.value = db_to_linear(Settings.audio_settings.sfx_db_value) * 100

	on_settings_show.emit()

func _on_master_slider_changed(value: float) -> void:
	_set_audio("Master", value)

func _on_music_slider_changed(value: float) -> void:
	_set_audio("Music", value)

func _on_sfx_slider_changed(value: float) -> void:
	_set_audio("SFX", value)
	
func _set_audio(bus_name: StringName, value: float) -> void:
	var db := linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)
	Settings.audio_settings["%s_db_value" % bus_name.to_lower()] = db

func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.fullscreen_enabled = toggled_on
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_back_pressed() -> void:
	Settings.save_settings()
	on_settings_hide.emit()
	queue_free()

func _on_reset_all_data_pressed() -> void:
	var confirm_scene := preload("res://scenes/screens/confirm_popup/confirm_popup.tscn")
	var popup := confirm_scene.instantiate()
	
	get_tree().root.add_child(popup)
	popup.set_content(
		"Reset all progress?",
		"This will delete all saved data and settings. This action cannot be undone.",
		"Permanently delete progress"
	)
	
	popup.accepted.connect(
		func():
			Settings.clear_settings()
			DatabaseManager.delete_all_data()
			SaveManager.clear_all_data()
			SceneManager.goto_scene("res://scenes/main.tscn")
	)
