extends Node

var inventory = {}

func add_item_to_inventory(
	item: String,
	value: int,
):
	print("added " + item + " with amount of " + str(value))
	inventory[item] = value
