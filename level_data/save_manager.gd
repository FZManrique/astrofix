extends Node

const SAVE_DIR := "user://save"

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

func get_save_path(level_id: String) -> String:
	return "%s/%s.tres" % [SAVE_DIR, level_id]

func save_level(resource: LevelResource) -> void:
	var path := get_save_path(resource.level_id)
	var err := ResourceSaver.save(resource, path)
	if err != OK:
		push_error("Failed to save level %s: %s" % [resource.level_id, err])

func load_level(level_id: String, fallback: LevelResource) -> LevelResource:
	var path := get_save_path(level_id)
	return ResourceLoader.load(path) if FileAccess.file_exists(path) else fallback

func clear_level(level_id: String) -> void:
	var path := get_save_path(level_id)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func clear_all_data() -> void:
	for file in DirAccess.get_files_at(SAVE_DIR):
		if file.ends_with(".tres"):
			DirAccess.remove_absolute(SAVE_DIR + "/" + file)
