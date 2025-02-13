extends Node

signal item_added(item: String, value: int)
signal item_removed(item: String, value: int)

var inventory := {}

func add_item_to_inventory(item: String, value: int) -> void:
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

func get_inventory_contents() -> Dictionary:
	return inventory

func simple_display_inventory() -> String:
	if inventory.size() == 0:
		return ""

	var item_list := []
	for item in inventory.keys():
		var quantity: int = inventory[item]
		if quantity > 1:
			item_list.append(item.capitalize() + " (" + str(quantity) + ")")
		else:
			item_list.append(item.capitalize())
	
	var formatted_inventory := ", ".join(item_list)
	return formatted_inventory

func _print_inventory() -> void:
	for item in inventory.keys():
		print(item + ": " + str(inventory[item]))

func _clear_inventory() -> void:
	inventory.clear()
	print("Inventory cleared.")
