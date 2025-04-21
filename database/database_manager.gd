extends Node

const DATABASE_ITEMS: Array[DatabaseItem] = [
	preload("res://database/resources/chloe.tres"),
	preload("res://database/resources/conny.tres"),
	preload("res://database/resources/dan.tres"),
	preload("res://database/resources/dragon_egg.tres"),
	preload("res://database/resources/franzen.tres"),
	preload("res://database/resources/fuel.tres"),
	preload("res://database/resources/gas_cover.tres"),
	preload("res://database/resources/jupiter.tres"),
	preload("res://database/resources/map.tres"),
	preload("res://database/resources/mars.tres"),
	preload("res://database/resources/nepturne.tres"),
	preload("res://database/resources/oxygen.tres"),
	preload("res://database/resources/painting.tres"),
	preload("res://database/resources/pen_wand.tres"),
	preload("res://database/resources/pop_album.tres"),
	preload("res://database/resources/saturn.tres"),
	preload("res://database/resources/scroll_and_quill.tres"),
	preload("res://database/resources/sword.tres"),
	preload("res://database/resources/uranus.tres"),
	preload("res://database/resources/william.tres"),
]


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
	load_unlocks()
#endregion


#region Database initialization
func _ready():
	load_database_items()
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

func load_database_items() -> void:
	for item in DATABASE_ITEMS:
		items.append(item)
		unlocked_items[item.resource_path] = item.unlocked
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
