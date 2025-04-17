extends Node

signal game_state_changed

enum PauseType { SYSTEM, PLAYER }

var pause_oxygen := false

var is_main_menu := false:
	get:
		return is_main_menu
	set(value):
		is_main_menu = value
		_emit_change()

var in_level_select := false:
	get:
		return in_level_select
	set(value):
		in_level_select = value
		_emit_change()

var in_cutscene := false:
	get:
		return in_cutscene
	set(value):
		in_cutscene = value
		_emit_change()

var in_dialogue := false:
	get:
		return in_dialogue
	set(value):
		in_dialogue = value
		_emit_change()

var is_transitioning := false:
	get:
		return is_transitioning
	set(value):
		is_transitioning = value
		_emit_change()
		
var in_minigame := false:
	get:
		return in_minigame
	set(value):
		in_minigame = value
		_emit_change()

var game_started := false:
	get:
		return game_started
	set(value):
		game_started = value
		_emit_change()

var current_cutscene: CutsceneResource
var current_level: LevelResource

var levels: Dictionary[StringName, LevelResource] = {}

var _fail_screen_active := false

var system_reasons := {}
var player_reasons := {}

const FailBox := preload("res://scripts/screens/fail_box.gd")


func _ready() -> void:
	TransitionManager.transition_started.connect(func() -> void: is_transitioning = true)
	TransitionManager.transition_finished.connect(func() -> void: is_transitioning = false)
	DialogueManager.passed_title.connect(func(_title: String) -> void: in_dialogue = true)
	DialogueManager.dialogue_ended.connect(func(_res: DialogueResource) -> void: in_dialogue = false)
	
	var dir = DirAccess.open("res://level_data/")
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var res = load("res://level_data/" + file) as LevelResource
			if res:
				levels[res.level_id] = res


func _emit_change() -> void:
	game_state_changed.emit()


func get_current_state() -> Dictionary:
	return {
		"main_menu": is_main_menu,
		"level_select": in_level_select,
		"cutscene": in_cutscene,
		"dialogue": in_dialogue,
		"transitioning": is_transitioning,
		"minigame": in_minigame,
		"started": game_started,
		"paused": should_game_pause()
	}


#region Level Saving/Loading
func get_completion_percent() -> float:
	var total := levels.size()
	var finished := 0
	for level: LevelResource in levels.values():
		if level.finished_level:
			finished += 1
	return finished / total if total > 0 else 0.0

func start_level(level_id: String, default_resource: LevelResource) -> void:
	current_level = SaveManager.load_level(level_id, default_resource)

func complete_level() -> void:
	current_level.finished_level = true
	SaveManager.save_level(current_level)

func save_level_progress() -> void:
	if current_level:
		SaveManager.save_level(current_level)

#endregion


#region Pausing
func add_pause_reason(type: PauseType, reason: String) -> void:
	match type:
		PauseType.SYSTEM:
			system_reasons[reason] = true
		PauseType.PLAYER:
			player_reasons[reason] = true
	_emit_change()


func remove_pause_reason(type: PauseType, reason: String) -> void:
	match type:
		PauseType.SYSTEM:
			system_reasons.erase(reason)
		PauseType.PLAYER:
			player_reasons.erase(reason)
	_emit_change()


func should_game_pause() -> bool:
	return system_reasons.size() > 0 or player_reasons.size() > 0


func can_player_toggle_pause() -> bool:
	return !is_main_menu and !is_transitioning and !in_cutscene and !in_level_select and system_reasons.size() == 0
#endregion

#region Failing/Quitting
func fail_game(on_restart: Callable) -> void:
	if _fail_screen_active:
		return
	_fail_screen_active = true
	var fail_node: FailBox = preload("res://scenes/screens/fail_scene.tscn").instantiate()
	get_tree().root.add_child(fail_node)
	fail_node.on_game_restart.connect(
		func():
			on_restart.call()
			_fail_screen_active = false
	)


func quit_game() -> void:
	if OS.has_feature("web"):
		TransitionManager.fade_to_black = true
		TransitionManager.transition()
		await TransitionManager.transition_finished
	get_tree().quit()
#endregion
