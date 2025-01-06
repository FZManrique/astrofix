class_name Globals
extends Node

var game_done = false

var disallow_inputs = false

var fuel_count = 0
var inventory = {}

func add_item_to_inventory(
	item: String,
	value: int,
):
	print("added " + item + " with amount of " + str(value))
	inventory[item] = value

func add_fuel(amount):
	fuel_count += amount
	print("Fuel: ", fuel_count)
