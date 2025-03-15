extends Node2D

var dialog = load("res://dialogue/level_2.dialogue")

func _ready() -> void:
	Music.play_music("res://audio/music/level_2.mp3", 100.0)
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(4)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			Music.stop_music()
			DialogueManager.show_dialogue_balloon(load("res://dialogue/level_1.dialogue"), "failed")
			DialogueManager.dialogue_ended.connect(
				func(_noop):
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
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
	print("in showinstructionbox")
	
	DataManager.show_instruction_box = true

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialog, key)

func _on_audio_stream_player_finished() -> void:
	$CanvasLayer/AudioStreamPlayer.play()


func _on_area_2d_body_entered_in_franz(body: Node2D) -> void:
	_show_dialoague_box("dialogue")

func _on_many_fuel_body_entered(body: Node2D) -> void:
	_show_dialoague_box("many_collected")
	DialogueManager.dialogue_ended.connect(
		func (_noop) -> void:
			if OS.has_feature('web'):
				DataManager.quit = true
				TransitionManager.transition()
				await TransitionManager.on_transition_finished
			
			get_tree().quit() 
	)

func _on_fuel_tank_fuel_collected(body: Node2D) -> void:
	$"Characters/Fuel Tank".force_pickup()
	_show_dialoague_box("collected")
	DialogueManager.dialogue_ended.connect(
		func (_noop) -> void:
			if OS.has_feature('web'):
				DataManager.quit = true
				TransitionManager.transition()
				await TransitionManager.on_transition_finished
				
			get_tree().quit() 
	)
