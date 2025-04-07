class_name Level3
extends Node2D

var Level3Data := DataManager.Level3
var is_transitioning := false

func _ready() -> void:
	if (not Level3Data.audio_playing):
		Level3Data.audio_playing = true
		Music.change_db(-16)
		Music.play_music("res://audio/music/level_3.wav")
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(7)
	($Characters/Chloe/AudioStreamPlayer2D as AudioStreamPlayer2D).play(Level3Data.song_time)
	
	OxygenManager.oxygen_depleted.connect(
		func() -> void:
			SceneManager.fail_game(
				func() -> void:
					on_restart(
						Level3Data.collected_cover, Level3Data.finished_intro
					)
			)
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

func _on_transition_to_minigame_body_entered(_body: Node2D) -> void:
	print(Level3Data.song_time)
	var song_time = ($Characters/Chloe/AudioStreamPlayer2D as AudioStreamPlayer2D).get_playback_position()
	Level3Data.song_time = song_time
	print(song_time, Level3Data.song_time)
	SceneManager.goto_scene("res://scenes/levels/level_3_minigame/minigame.tscn")

static func on_restart(collected_cover: bool = false, finished_intro: bool = false) -> void:
	InventoryManager._clear_inventory()
	OxygenManager.reset_timer()
	DataManager.Level3 = {
		talked_once_to_chloe = false,
		asked_for_help = false,
		in_asteroid_area = false,
		song_time = 0.0,
		audio_playing = false,
	}
	DataManager.Level3.finished_intro = finished_intro
	DataManager.Level3.collected_cover = collected_cover
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")

func _on_chloe_body_entered(_body: Node2D) -> void:
	if (not Level3Data.talked_once_to_chloe):
		Level3Data.talked_once_to_chloe = true
		_show_dialoague_box("dialogue_initial")
	else:
		_show_dialoague_box("general")

func _on_spaceship_body_entered(_body: Node2D) -> void:
	if (Level3Data.collected_cover):
		_show_dialoague_box("end_scene")
		DialogueManager.dialogue_ended.connect(
			func(_ignore) -> void:
				if (!is_transitioning):
					is_transitioning = true
					DataManager.current_cutscene = load("res://cutscenes/data/level_3_end.tres")
					SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
		)
	else:
		_show_dialoague_box("no_enter")

func _on_cover_body_entered(_body: Node2D) -> void:
	_show_dialoague_box("cover_collected")
	await DialogueManager.dialogue_ended
	GoalManager.go_to_next_goal(8)
	InventoryManager.add_item_to_inventory("cover", 1)
	%Cover.queue_free()
