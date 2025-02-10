# Globals class
# Handles scene changing 

extends Node

signal on_game_paused

var is_main_menu := true
var is_dialogue_shown := false
var current_scene: Node = null

func _ready() -> void:
	var root := get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	
	DialogueManager.passed_title.connect(
		_disallow_pause
	)
	DialogueManager.dialogue_ended.connect(
		_allow_pause
	)

func _process(_delta: float) -> void:
	if (
		!is_main_menu &&
		Input.is_action_just_pressed("ui_pause") &&
		!SceneManager.is_dialogue_shown
	):
		on_game_paused.emit()
		get_tree().paused = true
	
	if (SceneManager.is_dialogue_shown):
		OxygenManager.pause_timer()
	else:
		OxygenManager.start_timer()
	
func _allow_pause(_dialogue: DialogueResource) -> void:
	is_dialogue_shown = false

func _disallow_pause(_title: String) -> void:
	is_dialogue_shown = true

func goto_scene(path: String) -> void:
	if (path != "res://scenes/main.tscn"):
		is_main_menu = false
	else:
		is_main_menu = true
	
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s := ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
