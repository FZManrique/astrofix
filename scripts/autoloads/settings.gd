extends Node

const SETTINGS_PATH := "user://settings.cfg"

var audio_settings: Dictionary[String, float] = {
	master_db_value = 0,
	music_db_value = -3.2,
	sfx_db_value = 0,
}

var fullscreen_enabled := false

func _ready() -> void:
	load_settings()
	
	if (fullscreen_enabled):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	var audio := ["Master", "Music", "SFX"]
	var audio_indexes := audio_settings.values()
	for i in audio_settings.size():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio[i]), audio_indexes[i])

func save_settings():
	var config = ConfigFile.new()
	for key in audio_settings.keys():
		config.set_value("audio", key, audio_settings[key])
	config.set_value("display", "fullscreen_enabled", fullscreen_enabled)
	config.save(SETTINGS_PATH)

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		for key in audio_settings.keys():
			audio_settings[key] = config.get_value("audio", key, 0.0)
		fullscreen_enabled = config.get_value("display", "fullscreen_enabled", false)

func clear_settings():
	DirAccess.remove_absolute(SETTINGS_PATH)
