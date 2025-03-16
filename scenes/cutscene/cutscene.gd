extends Control

class CutsceneData:
	var max_page: int
	var end_scene: String
	
	func _init(max_page: int, end_scene: String) -> void:
		self.max_page = max_page
		self.end_scene = end_scene

enum CutsceneNames {
	LEVEL_1,
	LEVEL_1_END,
	LEVEL_2
}

var Cutscenes: Dictionary[CutsceneNames, CutsceneData] = {
	CutsceneNames.LEVEL_1: CutsceneData.new(5, "res://scenes/levels/level_1.tscn"),
	CutsceneNames.LEVEL_1_END: CutsceneData.new(2, "res://scenes/cutscene/cutscene.tscn"),
	CutsceneNames.LEVEL_2: CutsceneData.new(6, "res://scenes/levels/level_2.tscn")
}

var audio_map: Dictionary[int, Dictionary] = {
	CutsceneNames.LEVEL_1: {
		1: "res://audio/sfx/ambience/ceiling_fan.mp3",
		2: "res://audio/sfx/ambience/footsteps.mp3",
		3: "res://audio/sfx/door_open.mp3",
		4: "res://audio/sfx/ambience/flickering_lights.mp3"
	}
}

var cutscene_dialogue: Resource
var current_cutscene_number: int:
	get:
		return DataManager.Cutscene.current_cutscene_number
	set(value):
		DataManager.Cutscene.current_cutscene_number = value

var cutscene_data: CutsceneData
var current_title := 1

var is_end_mode: bool:
	set(value):
		DataManager.Cutscene.is_end_mode = value
	get:
		return DataManager.Cutscene.is_end_mode

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var dialogue_node: CutsceneDialogueBalloon
var dialogue_scene: PackedScene
var data_index: int = 1

func _ready() -> void:
	data_index = current_cutscene_number - 1 
	if (is_end_mode):
		data_index += 1
	
	cutscene_data = Cutscenes.get(data_index)
	cutscene_dialogue = load("res://dialogue/level_%s_cutscene.dialogue" % get_cutscene_item())
	
	dialogue_scene = load("res://dialogue/cutscene_dialogue/cutscene_dialogue.tscn") as PackedScene
	Music.play_music("res://audio/music/cutscene_%s.mp3" % get_cutscene_item())
	
	_on_title_changed()
	_show_scene()
	DialogueManager.dialogue_ended.connect(
		_on_dialogue_ended
	)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	current_title += 1
	if (current_title > cutscene_data.max_page):
		if (is_end_mode):
			is_end_mode = false
			current_cutscene_number += 1
		else:
			is_end_mode = true
		SceneManager.goto_scene(cutscene_data.end_scene)
	else:
		_on_title_changed()
		_show_scene()

func get_cutscene_item() -> String:
	var suffix: String = ""
	
	if (is_end_mode):
		suffix = "_end"
	
	return str(current_cutscene_number) + suffix

func _show_scene() -> void:
	texture_rect.texture = load("res://art/cutscenes/scene%s/0%s.png" % [get_cutscene_item(), current_title])
	dialogue_node = DialogueManager.show_dialogue_balloon_scene(dialogue_scene.instantiate(), cutscene_dialogue, "scene_" + str(current_title))

func _on_title_changed() -> void:
	$Timer.stop()
	$Timer.start()
	# stop audio
	audio_stream_player.stop()
	
	if audio_map.has(data_index) and audio_map[data_index].has(current_title):
		audio_stream_player.stream = load(audio_map[data_index][current_title])
		audio_stream_player.play()


func _on_timer_timeout() -> void:
	if is_instance_valid(dialogue_node):
		dialogue_node.dialogue_line = null
		_on_dialogue_ended(null)
		$Timer.start()
