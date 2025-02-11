extends Control

var cutscene_dialogue: Resource
var max_page: int

var Level1Cutscene := {
	max_page = 5,
	end_scene = "res://scenes/levels/level_1.tscn"
}
var Cutscenes := [Level1Cutscene]

var current_cutscene_number := DataManager.Cutscene.current_cutscene_number as int
var current_cutscene: Dictionary
var current_title := 1

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	DataManager.Cutscene.cutscene_mode = true
	
	current_cutscene = Cutscenes[current_cutscene_number - 1]
	max_page = current_cutscene.max_page
	
	cutscene_dialogue = load("res://dialogue/level%s_cutscene.dialogue" % current_cutscene_number)
	Music.play_music("res://audio/music/custcene_%s.mp3" % current_cutscene_number)
	
	_on_title_changed()
	DialogueManager.show_dialogue_balloon(cutscene_dialogue, "scene_" + str(current_title))
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	current_title += 1
	if (current_title > max_page):
		DataManager.Cutscene.cutscene_mode = false
		SceneManager.goto_scene(current_cutscene.end_scene)
	else:
		_on_title_changed()
		texture_rect.texture = load("res://art/cutscenes/level%s/0%s.png" % [current_cutscene_number, current_title])
		DialogueManager.show_dialogue_balloon(cutscene_dialogue, "scene_" + str(current_title))

func _on_title_changed() -> void:
	# stop audio
	audio_stream_player.stop()
	match current_cutscene_number:
		1:
			match current_title:
				2:
					audio_stream_player.stream = load("res://audio/sfx/ambience/footsteps.mp3")
					audio_stream_player.play()
				3:
					audio_stream_player.stream = load("res://audio/sfx/door_open.mp3")
					audio_stream_player.play()
				4:
					audio_stream_player.stream = load("res://audio/sfx/ambience/flickering_lights.mp3")
					audio_stream_player.play()
				_:
					audio_stream_player.stream = load("res://audio/sfx/ambience/ceiling_fan.mp3")
					audio_stream_player.play()
