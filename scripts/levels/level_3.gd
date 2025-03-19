extends Node2D

func _ready() -> void:
	Music.play_music("res://audio/music/level_3.wav")
	DataManager.intro_done = true

func _on_transition_to_minigame_body_entered(body: Node2D) -> void:
	SceneManager.goto_scene("res://scenes/levels/level_3_minigame/level_3_minigame.tscn")
