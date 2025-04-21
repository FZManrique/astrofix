extends Node2D

@onready var instructions: ColorRect = %Instructions
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
	GameStateManager.current_level = preload("res://level_data/level_3.tres")
	
	GameStateManager.in_minigame = true
	OxygenManager.oxygen_depleted.connect(
		func():
			GameStateManager.fail_game(Level3.on_restart)
	)
	
	if (GameStateManager.current_level.flag_bool[&"in_asteroid_area"]):
		player.position = Vector2(2152.0, 244.0)
	else:
		player.position = Vector2(174.0, 378)
	
	$AudioStreamPlayer2D.play(GameStateManager.current_level.flag_float[&"song_time"])
	
	instructions.show()
	$GUI/Instructions/VBoxContainer/VBoxContainer/PlayGame.grab_focus()
	GameStateManager.add_pause_reason(GameStateManager.PauseType.SYSTEM, "level_3_instructions")
	PauseManager.add_whitelist(instructions)


func _on_to_planet_body_entered(body: Node2D) -> void:
	GameStateManager.in_minigame = true
	GameStateManager.current_level.flag_bool[&"in_asteroid_area"] = false
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")
	GameStateManager.current_level.flag_float[&"song_time"] = $AudioStreamPlayer2D.get_playback_position()

func _on_to_asteroid_body_entered(body: Node2D) -> void:
	GameStateManager.in_minigame = true
	GameStateManager.current_level.flag_bool[&"in_asteroid_area"] = true
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")
	GameStateManager.current_level.flag_float[&"song_time"] = $AudioStreamPlayer2D.get_playback_position()

func _on_killzone_body_entered(body: Node2D) -> void:
	GameStateManager.fail_game(
		func() -> void:
			Level3.on_restart()
	)

func _on_play_game_pressed() -> void:
	instructions.hide()
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "level_3_instructions")
	PauseManager.remove_whitelist(instructions)
