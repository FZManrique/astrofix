# Globals class
extends Node

var game_done = false
var disallow_inputs = false

var fuel_count = 0
var inventory = {}

var current_scene = null

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)

# See https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func add_item_to_inventory(
	item: String,
	value: int,
):
	print("added " + item + " with amount of " + str(value))
	inventory[item] = value

func add_fuel(amount):
	fuel_count += amount
	print("Fuel: ", fuel_count)
