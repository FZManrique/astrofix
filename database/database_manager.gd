extends Node

var items: Array[DatabaseItem] = []
var unlocked_items: Dictionary[String, bool] = {}

const SAVE_PATH := "user://database_unlocks.cfg"

signal item_unlocked(item_name: String)


#region Persisting
func save_unlocks():
	var cfg = ConfigFile.new()
	for path in unlocked_items.keys():
		cfg.set_value("unlocks", path, unlocked_items[path])
	cfg.save(SAVE_PATH)


func load_unlocks():
	var cfg = ConfigFile.new()
	var err = cfg.load(SAVE_PATH)
	if err != OK:
		return  # No file yet

	for path in unlocked_items.keys():
		unlocked_items[path] = cfg.get_value("unlocks", path, false)

func delete_all_data():
	DirAccess.remove_absolute(SAVE_PATH)
	load_database_items("res://database/resources")
	load_unlocks()
#endregion


#region Database initialization
func _ready():
	load_database_items("res://database/resources")
	load_unlocks()
	item_unlocked.connect(
		func(item: String) -> void:
			print(item)
	)

signal navigate_to(item: DatabaseItem)

func navigate_to_entry(name: String) -> bool:
	for item in items:
		if item.name == name:
			navigate_to.emit(item)
			return true
	return false

func load_database_items(path: String) -> void:
	var dir := DirAccess.open(path)
	if !dir:
		return
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".tres"):
			var res_path = path + "/" + file
			var item: DatabaseItem = load(res_path)
			if item:
				items.append(item)
				unlocked_items[res_path] = item.unlocked
		file = dir.get_next()
	dir.list_dir_end()
#endregion


#region Unlocking items
func set_unlocked(path: String, state: bool) -> void:
	unlocked_items[path] = state
	save_unlocks()
	item_unlocked.emit((load(path) as DatabaseItem).name)


func unlock_item_by_name(item_name: String):
	for item in items:
		if item.name == item_name:
			if (unlocked_items[item.resource_path]): return
			unlocked_items[item.resource_path] = true
			save_unlocks()
			item_unlocked.emit(item_name)

func unlock_item_by_path(path: String):
	if unlocked_items.has(path):
		if (unlocked_items[path]): return
		unlocked_items[path] = true
		save_unlocks()
		item_unlocked.emit((load(path) as DatabaseItem).name)


func is_unlocked(item_name: String) -> bool:
	for item in items:
		if item.name == item_name:
			return unlocked_items.get(item.resource_path, false)
	return false
#endregion
