extends Node2D

var Data := DataManager.Level5

signal show_dan

func _ready() -> void:
	Music.play_music("res://audio/music/level_5.mp3")
	GoalManager.go_to_next_goal(13)
	DataManager.intro_done = false
	
	$CanvasLayer/InstructionBox.connect(
		"instruction_box_dismissed",
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
	)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			SceneManager.fail_game(
				func() -> void:
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
					SceneManager.goto_scene("res://scenes/levels/level_5.tscn")
			)
	)
	
	DataManager.show_dan.connect(
		func() -> void:
			(%Dan as Node2D).process_mode = Node.PROCESS_MODE_INHERIT
			(%Dan as Node2D).show()
	)
	
	(%Dan as Node2D).process_mode = Node.PROCESS_MODE_DISABLED
	(%Dan as Node2D).hide()
	DataManager.show_instruction_box = true

func _on_dan_area_body_entered(body: Node2D) -> void:
	_show_dialoague_box("talk_to_dan")
	await DialogueManager.dialogue_ended
	GoalManager.go_to_next_goal(14)
	SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_1/minigame_1.tscn")

func _on_encounter_many_tanks_body_entered(body: Node2D) -> void:
	_show_dialoague_box("empty_canisters")
	await DialogueManager.dialogue_ended
	$Characters/EncounterManyTanks.queue_free()

func _show_dialoague_box(key: StringName) -> void:
	DialogueManager.show_dialogue_balloon(preload("res://dialogue/level_5.dialogue"), key)
