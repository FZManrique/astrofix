extends Node2D

var dialog = load("res://dialogue/level_2.dialogue")
var Level2Data := DataManager.Level2
var WIND_DIRECTION := DataManager.WIND_DIRECTION

var has_entered = false

func _ready() -> void:
	%WindAnim.play("fade_out")
	if (not Level2Data.audio_playing):
		Level2Data.audio_playing = true
		Music.play_music("res://audio/music/level_2.mp3", 100.0)
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(4)
	
	OxygenManager.oxygen_depleted.connect(
		func() -> void:
			SceneManager.fail_game(
				func() -> void:
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
					Level2Data.has_fixed_spacesuit = false
					SceneManager.goto_scene("res://scenes/levels/level_2.tscn")
			)
	)

	$CanvasLayer/InstructionBox.connect(
		"instruction_box_dismissed",
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
	)
	
	if (!Level2Data.has_fixed_spacesuit):
		DataManager.show_instruction_box = true
	else:
		$Characters/Player.position = Vector2(1320, 705)
		_show_dialoague_box("intro_part3")
	
	for area: WindArea in $Wind.get_children():
		area.on_enter.connect(
			func() -> void:
				%WindAnim.play("fade_in")
				await %WindAnim.animation_finished
				match Level2Data.wind_direction:
					WIND_DIRECTION.TO_TOP:
						%WindAnim.play("to_top")
					WIND_DIRECTION.TO_BOTTOM:
						%WindAnim.play("to_bottom")
					WIND_DIRECTION.TO_LEFT:
						%WindAnim.play("to_right")
					WIND_DIRECTION.TO_RIGHT:
						%WindAnim.play("to_left")
		)
		area.on_exit.connect(
			func() -> void:
				%WindAnim.play("fade_out")
		)

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialog, key)

func _on_audio_stream_player_finished() -> void:
	$CanvasLayer/AudioStreamPlayer.play()

func _on_area_2d_body_entered_in_franz(body: Node2D) -> void:
	_show_dialoague_box("dialogue")

func _on_many_fuel_body_entered(body: Node2D) -> void:
	if (!Level2Data.fuel_collected):
		_show_dialoague_box("many_collected")

func _on_fuel_tank_fuel_collected(body: Node2D) -> void:
	if (!Level2Data.fuel_collected):
		$"Characters/Fuel Tank".force_pickup()
		_show_dialoague_box("collected")

func _on_player_entered_to_starting_area(body: Node2D) -> void:
	if (!Level2Data.in_starting_area):
		Level2Data.in_starting_area = true
		GoalManager.go_to_next_goal(5)
		_show_dialoague_box("intro_part2")
		DialogueManager.dialogue_ended.connect(
			func(_noop):
				if (!Level2Data.has_fixed_spacesuit):
					SceneManager.goto_scene("res://scenes/levels/level_2_minigame/minigame.tscn")
		)

func _on_spaceship_body_entered(body: Node2D) -> void:
	if (Level2Data.fuel_collected):
		_show_dialoague_box("on_enter")
		DialogueManager.dialogue_ended.connect(
			func(_noop):
				if (!has_entered):
					has_entered = true
					print("Transitioning to level 3")
					DataManager.current_cutscene = load("res://cutscenes/data/level_2_end.tres")
					SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
		)
	else:
		_show_dialoague_box("no_enter")
