extends Control

var cutscene_dialogue: Resource
var max_page: int

var Level1Cutscene: Dictionary[String, Variant] = {
	max_page = 5,
	end_scene = "res://scenes/levels/level_1.tscn"
}
var Level1EndCutscene: Dictionary[String, Variant] = {
	max_page = 2,
	end_scene = "res://scenes/cutscene/cutscene.tscn"
}
var Level2Cutscene: Dictionary[String, Variant] = {
	max_page = 6,
	end_scene = "res://scenes/levels/level_2.tscn"
}

var Cutscenes := [Level1Cutscene, Level1EndCutscene, Level2Cutscene]

var current_cutscene_number := DataManager.Cutscene.current_cutscene_number as float
var current_cutscene: Dictionary
var current_title := 1

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var dialogue: Node

func _ready() -> void:
	DataManager.Cutscene.cutscene_mode = true
	
	current_cutscene = Cutscenes[int(current_cutscene_number * 2) - 2]
	max_page = current_cutscene.max_page
	
	cutscene_dialogue = load("res://dialogue/level%s_cutscene.dialogue" % current_cutscene_number)
	var dialogue_scene := load("res://dialogue/cutscene/balloon.tscn") as PackedScene
	
	Music.play_music("res://audio/music/cutscene_%s.mp3" % current_cutscene_number)
	
	_on_title_changed()
	texture_rect.texture = load("res://art/cutscenes/scene%s/0%s.png" % [current_cutscene_number, current_title])
	dialogue = DialogueManager.show_dialogue_balloon_scene(dialogue_scene.instantiate(), cutscene_dialogue, "scene_" + str(current_title))
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	current_title += 1
	if (current_title > max_page):
		DataManager.Cutscene.cutscene_mode = false
		DataManager.Cutscene.current_cutscene_number += 0.5
		SceneManager.goto_scene(current_cutscene.end_scene)
	else:
		_on_title_changed()
		texture_rect.texture = load("res://art/cutscenes/scene%s/0%s.png" % [current_cutscene_number, current_title])
		var dialogue_scene := load("res://dialogue/cutscene/balloon.tscn") as PackedScene
		dialogue = DialogueManager.show_dialogue_balloon_scene(dialogue_scene.instantiate(), cutscene_dialogue, "scene_" + str(current_title))


func _on_title_changed() -> void:
	$Timer.stop()
	$Timer.start()
	# stop audio 
	audio_stream_player.stop()
	match current_cutscene_number:
		1:
			match current_title:
				1:
					audio_stream_player.stream = load("res://audio/sfx/ambience/ceiling_fan.mp3")
					audio_stream_player.play()
				2:
					audio_stream_player.stream = load("res://audio/sfx/ambience/footsteps.mp3")
					audio_stream_player.play()
				3:
					audio_stream_player.stream = load("res://audio/sfx/door_open.mp3")
					audio_stream_player.play()
				4:
					audio_stream_player.stream = load("res://audio/sfx/ambience/flickering_lights.mp3")
					audio_stream_player.play()


func _on_timer_timeout() -> void:
	var menu := dialogue.get_node("Balloon/Panel/Dialogue/Responses/ResponsesMenu") as DialogueResponsesMenu
	var button := menu.get_child(0) as Button
	button.set_pressed(true)
	$Timer.start()
