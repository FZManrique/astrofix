extends Control

var dialog = load("res://dialogue/level1_cutscene.dialogue")
var current_title := 1
var max_title := 5

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	Music.play_music("res://audio/music/custcene_1.mp3")
	
	Settings.show_background_and_characters = false
	DialogueManager.show_dialogue_balloon(dialog, "scene_" + str(current_title))
	DialogueManager.connect("dialogue_ended",
		_on_dialogue_ended		
	)

func _on_dialogue_ended(resource: DialogueResource):
	current_title += 1
	if (current_title > max_title):
		Settings.show_background_and_characters = true
		SceneManager.goto_scene("res://scenes/levels/level_1.tscn")
	else:
		_on_title_changed()
		texture_rect.texture = load("res://art/cutscenes/level1/0%s.png" % current_title)
		DialogueManager.show_dialogue_balloon(dialog, "scene_" + str(current_title))

func _on_title_changed():
	# stop audio
	audio_stream_player.stop()
	match current_title:
		1:
			audio_stream_player.stream = load("res://audio/sfx/ambience/ceiling_fan.mp3")
			audio_stream_player.play(18.0)
		2:
			audio_stream_player.stream = load("res://audio/sfx/ambience/footsteps.mp3")
			audio_stream_player.play()
		3:
			audio_stream_player.stream = load("res://audio/sfx/door_open.mp3")
			audio_stream_player.play()
		4:
			audio_stream_player.stream = load("res://audio/sfx/ambience/flickering_lights.mp3")
			audio_stream_player.play()
