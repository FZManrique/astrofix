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
		func(_title: String) -> void:
			is_dialogue_shown = true
	)
	DialogueManager.dialogue_ended.connect(
		func(_resource: DialogueResource) -> void:
			is_dialogue_shown = false
	)

func _process(_delta: float) -> void:
	_check_if_main_menu()
	_determine_can_pause()

	if (
		(DataManager.can_pause && Input.is_action_just_pressed("ui_pause")) || DataManager.show_instruction_box
	):
		print("Game paused")
		on_game_paused.emit()
		get_tree().paused = true
	
	if (is_main_menu || DataManager.Level2.is_minigame || DataManager.in_cutscene || DataManager.Level5.in_minigame):
		_toggle_oxygen_timer(false)
	else:	
		_toggle_oxygen_timer(!SceneManager.is_dialogue_shown) 

const FailBox := preload("res://scripts/screens/fail_box.gd") 
func fail_game(on_restart: Callable) -> void:
	var fail_scene := preload("res://scenes/screens/fail_scene.tscn")
	var fail_node: FailBox = fail_scene.instantiate()
	add_child(fail_node)
	fail_node.on_game_restart.connect(on_restart)

func quit_game() -> void:
	if OS.has_feature('web'):
		DataManager.should_quit = true
		TransitionManager.transition()
		await TransitionManager.on_transition_finished
		
	get_tree().quit() 

#region Checks
func _toggle_oxygen_timer(enabled: bool) -> void:
	if (enabled):
		OxygenManager.start_timer()
	else:
		OxygenManager.pause_timer()
	
func _determine_can_pause() -> void:
	DataManager.can_pause = !is_main_menu && !SceneManager.is_dialogue_shown && !DataManager.in_cutscene

func _check_if_main_menu() -> void:
	if (get_tree().current_scene.scene_file_path == "res://scenes/main.tscn"):
		is_main_menu = true
	else:
		is_main_menu = false
#endregion

#region Scene Transitions

func goto_scene(path: String) -> void:
	TransitionManager.transition()
	DataManager.can_pause = false
	await TransitionManager.on_transition_finished
	_determine_can_pause()
	
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s := ResourceLoader.load(path) as PackedScene
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func goto_packed_scene(scene: PackedScene) -> void:
	TransitionManager.transition()
	DataManager.can_pause = false
	await TransitionManager.on_transition_finished
	_determine_can_pause()
	
	var run := func() -> void:
		current_scene.free()
		current_scene = scene.instantiate()
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
	
	run.call_deferred()
	
#endregion
