class_name Level3
extends Node2D

var Level3Data := DataManager.Level3

func _ready() -> void:
	Music.change_db(-16)
	Music.play_music("res://audio/music/level_3.wav")
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(7)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			SceneManager.fail_game(on_restart)
	)
	
	$CanvasLayer/InstructionBox.connect(
		"instruction_box_dismissed",
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
	)
	
	if (Level3Data.finished_intro):
		if (Level3Data.in_asteroid_area):
			%Player.position = Vector2(1867, 403.0)
			%CameraA.enabled = false
			%CameraB.enabled = true
		else:
			%Player.position = Vector2(793.0, 368.0)
			%CameraA.enabled = true
			%CameraB.enabled = false
	else:
		Level3Data.finished_intro = true
		DataManager.show_instruction_box = true

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/level_3.dialogue"), key)

func _on_transition_to_minigame_body_entered(body: Node2D) -> void:
	SceneManager.goto_scene("res://scenes/levels/level_3_minigame/level_3_minigame.tscn")

static func on_restart() -> void:
	InventoryManager._clear_inventory()
	OxygenManager.reset_timer()
	DataManager.Level3 = {
		talked_once_to_chloe = false,
		asked_for_help = false,
		finished_intro = false,
		collected_cover = false,
		in_asteroid_area = false,
	}
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")

func _on_chloe_body_entered(body: Node2D) -> void:
	if (not Level3Data.talked_once_to_chloe):
		Level3Data.talked_once_to_chloe = true
		_show_dialoague_box("dialogue_initial")
	else:
		_show_dialoague_box("general")

func _on_spaceship_body_entered(body: Node2D) -> void:
	if (Level3Data.collected_cover):
		_show_dialoague_box("end_scene")
		DialogueManager.dialogue_ended.connect(
			func(_ignore) -> void:
				SceneManager.quit_game()
		)
	else:
		_show_dialoague_box("no_enter")

func _on_cover_body_entered(_body: Node2D) -> void:
	_show_dialoague_box("cover_collected")
	await DialogueManager.dialogue_ended
	%Cover.queue_free()
