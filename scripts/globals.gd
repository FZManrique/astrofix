# Globals class
extends Node

const OxygenDefaults = {
	default = 60,
	decrease_rate = 1.0,
}

signal on_game_paused

var disallow_inputs = false
var inventory = {}

var is_main_menu = true
var is_dialogue_shown = false
var current_scene = null

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	
	DialogueManager.passed_title.connect(
		_disallow_pause
	)
	DialogueManager.dialogue_ended.connect(
		_allow_pause
	)

func _process(delta: float) -> void:
	if (
		!is_main_menu &&
		Input.is_action_just_pressed("ui_pause") &&
		!Globals.is_dialogue_shown
	):
		on_game_paused.emit()
		get_tree().paused = true
	
func _allow_pause(_ig):
	is_dialogue_shown = false

func _disallow_pause(_ig):
	is_dialogue_shown = true

# See https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
func goto_scene(path):
	if (path != "res://scenes/main-scenes/main.tscn"):
		is_main_menu = false
	else:
		is_main_menu = true
	
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
