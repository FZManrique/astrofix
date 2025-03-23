extends Node2D

var Level4Data := DataManager.Level4

func _ready() -> void:
	Music.change_db(0)
	Music.play_music("res://audio/music/level_4.mp3")
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(9)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			SceneManager.fail_game(
				func() -> void:
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
					SceneManager.goto_scene("res://scenes/levels/level_4.tscn")
			)
	)
	
	$CanvasLayer/InstructionBox.connect(
		"instruction_box_dismissed",
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
	)
	
	%Shards.visible = false
	
	DataManager.show_instruction_box = true

func _on_conny_body_entered(body: Node2D) -> void:
	# See dialogue for logic
	if (Level4Data.talked_to_conny):
		if (Level4Data.crystal_count == 4):
			if (Level4Data.talked_after_most_crystals):
				_show_dialoague_box("uncertain")
			else:
				_show_dialoague_box("discussion")
		else:
			_show_dialoague_box("already_talked")
	else:
		_show_dialoague_box("initial_talk")
		await DialogueManager.dialogue_ended
		%Shards.visible = true
		GoalManager.go_to_next_goal(10)


func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/level_4.dialogue"), key)
