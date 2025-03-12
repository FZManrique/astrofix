extends Node2D

var dialog = load("res://dialogue/level2.dialogue")

func _ready() -> void:
	Music.play_music("res://audio/music/level_2.mp3", 100.0)
	 
	DialogueManager.show_dialogue_balloon(dialog, "intro")
	


func _on_audio_stream_player_finished() -> void:
	$CanvasLayer/AudioStreamPlayer.play()
