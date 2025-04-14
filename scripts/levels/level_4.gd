extends Node2D

var Level4Data := DataManager.Level4
var died := false

func _ready() -> void:
	Music.change_db(0)
	Music.play_music("res://audio/music/level_4.mp3")
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(9)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			if (not died):
				died = true
				SceneManager.fail_game(
					func() -> void:
						InventoryManager._clear_inventory()
						OxygenManager.reset_timer()
						SceneManager.goto_scene("res://scenes/levels/level_4.tscn")
				)
	)
	
	DataManager.Level4_has_done_confrontation.connect(
		func() -> void:
			var minigame = preload("res://scenes/levels/level_4_minigame/minigame.tscn") as PackedScene
			var minigame_node = minigame.instantiate()
			
			add_child(minigame_node)
			minigame_node.on_dismiss.connect(
				func():
					_show_dialoague_box("ending")
					await DialogueManager.dialogue_ended
					DataManager.current_cutscene = preload("res://cutscenes/data/level_4_end.tres")
					SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
			)
	)
	
	$CanvasLayer/InstructionBox.connect(
		"instruction_box_dismissed",
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
	)
	
	for spike in \
		($Tilemap/Decorations/Medium/Type1.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Medium/Type2.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Large/Type1.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Large/Type2.get_children() as Array[Spike]):
		spike.player_hit.connect(
			func() -> void:
				print("yes")
				($CanvasLayer/Screen as GUI).take_damage()
		)
	
	%Shards.visible = false
	
	DataManager.show_instruction_box = true

func _on_conny_body_entered(body: Node2D) -> void:
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
	DialogueManager.show_dialogue_balloon(preload("res://dialogue/level_4.dialogue"), key)
