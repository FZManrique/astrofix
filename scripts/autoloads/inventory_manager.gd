extends Node

var ITEMS: Dictionary[String, Texture] = {
	"key": preload("res://art/objects/key.png"),
	"fuel": preload("res://art/objects/fuel_tank.png"),
	"cover": preload("res://art/level_3/gas_cover.png"),
	"crystal": preload("res://art/level_4/crystal_small/1.png"),
	"map": preload("res://art/level_4/map_inventory.png")
}

func get_icon(item: String) -> Texture:
	return ITEMS.get(item, null)

signal item_added(item: String, value: int)
signal item_removed(item: String, value: int)

var inventory := {}

func add_item_to_inventory(item: String, value: int) -> void:
	assert(ITEMS.has(item), "Invalid item: " + item)

	if value <= 0:
		print("Cannot add a non-positive amount of " + item)
		return

	if item in inventory:
		inventory[item] += value
	else:
		inventory[item] = value

	print("Added " + item + " with amount of " + str(value))
	item_added.emit(item, value)

func remove_item_from_inventory(item: String, value: int) -> void:
	if value <= 0:
		print("Cannot remove a non-positive amount of " + item)
		return

	if item in inventory:
		if inventory[item] > value:
			inventory[item] -= value
			print("Removed " + str(value) + " of " + item)
			item_removed.emit(item, value)
		elif inventory[item] == value:
			print("Removed all of " + item)
			inventory.erase(item)
			item_removed.emit(item, value)
		else:
			print("Not enough " + item + " to remove.")
	else:
		print(item + " not found in inventory.")


func _clear_inventory() -> void:
	inventory.clear()
	print("Inventory cleared.")
