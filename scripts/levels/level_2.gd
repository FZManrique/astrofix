extends Node2D

const InstructionBox := preload("res://scripts/screens/instruction_box.gd")

@export var level_resource: Level2Resource = GameStateManager.levels.get("Uranus")

@onready var wind_anim: AnimationPlayer = %WindAnim
@onready var instruction_box: InstructionBox = $CanvasLayer/InstructionBox

var dialog = preload("res://dialogue/level_2.dialogue")

var WIND_DIRECTION := Level2Resource.WindDirection

func _ready() -> void:
	wind_anim.play("fade_out")
	GameStateManager.start_level(level_resource.level_id, level_resource)
	
	if (not GameStateManager.current_level.flag_bool[&"audio_playing"]):
		GameStateManager.current_level.flag_bool[&"audio_playing"] = true
		Music.play_music("res://audio/music/level_2.mp3", 100.0)
	
	if (not GameStateManager.current_level.flag_bool[&"has_fixed_spacesuit"]):
		GoalManager.go_to_next_goal(4)
	
	DataManager.intro_done = false
	
	OxygenManager.oxygen_depleted.connect(
		func() -> void:
			GameStateManager.fail_game(
				func() -> void:
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
					GameStateManager.current_level.flag_bool[&"has_fixed_spacesuit"] = false
					SceneManager.goto_scene("res://scenes/levels/level_2.tscn")
			)
	)

	instruction_box.instruction_box_dismissed.connect(
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
				await DialogueManager.dialogue_ended
				DatabaseManager.unlock_item_by_name("Uranus")
	)
	
	if (not GameStateManager.current_level.flag_bool[&"has_fixed_spacesuit"]):
		instruction_box.show_instruction_box()
	else:
		$Characters/Player.position = Vector2(1320, 705)
		_show_dialoague_box("intro_part3")
		await DialogueManager.dialogue_ended
		DatabaseManager.unlock_item_by_name("Franzen Albert II") 
	
	for area in ($Wind.get_children() as Array[WindArea]):
		area.on_enter.connect(
			func() -> void:
				wind_anim.play("fade_in")
				await wind_anim.animation_finished
				match (GameStateManager.current_level as Level2Resource).wind_direction:
					WIND_DIRECTION.TO_TOP:
						wind_anim.play("to_top")
					WIND_DIRECTION.TO_BOTTOM:
						wind_anim.play("to_bottom")
					WIND_DIRECTION.TO_LEFT:
						wind_anim.play("to_right")
					WIND_DIRECTION.TO_RIGHT:
						wind_anim.play("to_left")
		)
		area.on_exit.connect(
			func() -> void:
				wind_anim.play("fade_out")
		)

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialog, key)

func _on_audio_stream_player_finished() -> void:
	$CanvasLayer/AudioStreamPlayer.play()

func _on_area_2d_body_entered_in_franz(body: Node2D) -> void:
	_show_dialoague_box("dialogue")

func _on_many_fuel_body_entered(body: Node2D) -> void:
	if (!GameStateManager.current_level.flag_bool[&"fuel_collected"]):
		InventoryManager.add_item_to_inventory("fuel", 10)
		$Characters/ManyFuel.hide()
		_show_dialoague_box("many_collected")

func _on_fuel_tank_fuel_collected(body: Node2D) -> void:
	if (!GameStateManager.current_level.flag_bool[&"fuel_collected"]):
		$"Characters/Fuel Tank".force_pickup()
		_show_dialoague_box("collected")

func _on_player_entered_to_starting_area(body: Node2D) -> void:
	if (not GameStateManager.current_level.flag_bool[&"in_starting_area"]):
		GameStateManager.current_level.flag_bool[&"in_starting_area"] = true
		GoalManager.go_to_next_goal(5)
		_show_dialoague_box("intro_part2")
		DialogueManager.dialogue_ended.connect(
			func(_noop):
				if (not GameStateManager.current_level.flag_bool[&"has_fixed_spacesuit"]):
					SceneManager.goto_scene("res://scenes/levels/level_2_minigame/minigame.tscn")
		)

func _on_spaceship_body_entered(body: Node2D) -> void:
	if (GameStateManager.current_level.flag_bool[&"fuel_collected"]):
		_show_dialoague_box("on_enter")
		await DialogueManager.dialogue_ended
		
		if (GameStateManager.current_level.finished_level):
			return
		GameStateManager.complete_level()
		
		print("Transitioning to level 3")
		GameStateManager.current_cutscene = preload("res://cutscenes/data/level_2_end.tres")
		SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")

	else:
		_show_dialoague_box("no_enter")
