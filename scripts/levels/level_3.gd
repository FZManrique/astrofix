class_name Level3
extends Node2D

@export var level_resource: LevelResource = GameStateManager.levels.get("Saturn")

const InstructionBox := preload("res://scripts/screens/instruction_box.gd")
@onready var instruction_box: InstructionBox = $CanvasLayer/InstructionBox

@onready var current_level_data: LevelResource = GameStateManager.current_level

func _ready() -> void:
	GameStateManager.start_level(level_resource.level_id, level_resource)

	Music.change_db(-16)
	Music.play_music("res://audio/music/level_3.wav")
	
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(7)
	
	($Characters/Chloe/AudioStreamPlayer2D as AudioStreamPlayer2D).play(current_level_data.flag_float[&"song_time"])
	
	OxygenManager.oxygen_depleted.connect(
		func() -> void:
			GameStateManager.fail_game(
				func() -> void:
					on_restart(
						current_level_data.flag_bool[&"collected_cover"], 
						current_level_data.flag_bool[&"finished_intro"]
					)
			)
	)
	
	instruction_box.instruction_box_dismissed.connect(
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
				await DialogueManager.dialogue_ended
				DatabaseManager.unlock_item_by_name("Saturn")
	)
	
	if (current_level_data.flag_bool[&"finished_intro"]):
		if (current_level_data.flag_bool[&"in_asteroid_area"]):
			%Player.position = Vector2(1867, 403.0)
			%CameraA.enabled = false
			%CameraB.enabled = true
		else:
			%Player.position = Vector2(793.0, 368.0)
			%CameraA.enabled = true
			%CameraB.enabled = false
	else:
		current_level_data.flag_bool[&"finished_intro"] = true
		instruction_box.show_instruction_box()

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(preload("res://dialogue/level_3.dialogue"), key)

func _on_transition_to_minigame_body_entered(_body: Node2D) -> void:
	var song_time = ($Characters/Chloe/AudioStreamPlayer2D as AudioStreamPlayer2D).get_playback_position()
	current_level_data.flag_float[&"song_time"] = song_time
	SceneManager.goto_scene("res://scenes/levels/level_3_minigame/minigame.tscn")

static func on_restart(collected_cover: bool = false, finished_intro: bool = false) -> void:
	InventoryManager._clear_inventory()
	OxygenManager.reset_timer()
	GameStateManager.current_level = preload("res://level_data/level_3.tres")
	
	GameStateManager.current_level.flag_bool[&"finished_intro"] = finished_intro
	GameStateManager.current_level.flag_bool[&"collected_cover"] = collected_cover
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")

func _on_chloe_body_entered(_body: Node2D) -> void:
	if (not current_level_data.flag_bool[&"talked_once_to_chloe"]):
		current_level_data.flag_bool[&"talked_once_to_chloe"] = true
		_show_dialoague_box("dialogue_initial")
		await DialogueManager.dialogue_ended
		DatabaseManager.unlock_item_by_name("Chloe LouiSZA") 
	else:
		_show_dialoague_box("general")

func _on_spaceship_body_entered(_body: Node2D) -> void:
	if (current_level_data.flag_bool[&"collected_cover"]):
		_show_dialoague_box("end_scene")
		DialogueManager.dialogue_ended.connect(
			func(_ignore) -> void:
				if (current_level_data.finished_level):
					return
				
				GameStateManager.complete_level()
					
				InventoryManager.remove_item_from_inventory("cover", 1)
				GameStateManager.current_cutscene = preload("res://cutscenes/data/level_3_end.tres")
				SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
		)
	else:
		_show_dialoague_box("no_enter")

func _on_cover_body_entered(_body: Node2D) -> void:
	current_level_data.flag_bool[&"collected_cover"] = true
	_show_dialoague_box("cover_collected")
	await DialogueManager.dialogue_ended
	DatabaseManager.unlock_item_by_name("Gas Cover")
	GoalManager.go_to_next_goal(8)
	InventoryManager.add_item_to_inventory("cover", 1)
	%Cover.queue_free()
