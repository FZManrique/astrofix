extends Control

class CutsceneData:
	var max_page: int
	var end_scene: String
	
	func _init(a: int, b: String) -> void:
		max_page = a
		end_scene = b

enum CutsceneNames {
	LEVEL_1,
	LEVEL_1_END,
	LEVEL_2,
	LEVEL_2_END,
	LEVEL_3
}

var Cutscenes: Dictionary[CutsceneNames, CutsceneData] = {
	CutsceneNames.LEVEL_1: CutsceneData.new(5, "res://scenes/levels/level_1.tscn"),
	CutsceneNames.LEVEL_1_END: CutsceneData.new(2, "res://scenes/levels/level_transition.tscn"),
	CutsceneNames.LEVEL_2: CutsceneData.new(6, "res://scenes/levels/level_2.tscn"),
	CutsceneNames.LEVEL_2_END: CutsceneData.new(2, "res://scenes/levels/level_transition.tscn"),
	CutsceneNames.LEVEL_3: CutsceneData.new(4, "res://scenes/levels/level_3.tscn"),
}

func get_cutscene(index) -> CutsceneData:
	if (is_end_mode):
		return Cutscenes.get((index * 2) - 1)
	else:
		return Cutscenes.get((index * 2) - 2)

var audio_map: Dictionary[int, Dictionary] = {
	CutsceneNames.LEVEL_1: {
		1: "res://audio/sfx/ambience/ceiling_fan.mp3",
		2: "res://audio/sfx/ambience/footsteps.mp3",
		3: "res://audio/sfx/door_open.mp3",
		4: "res://audio/sfx/ambience/flickering_lights.mp3"
	},
	CutsceneNames.LEVEL_1_END: {
		1: "res://audio/cutscene/level_1_end/enter.mp3",
		2: "res://audio/cutscene/level_1_end/takeoff.mp3"
	},
	CutsceneNames.LEVEL_3: {
		3: "res://audio/cutscene/level_3/explosion.mp3"
	}
}

var mutations = {
	CutsceneNames.LEVEL_3: {
		1: func() -> void:
			var node = _custom_sfx("res://audio/cutscene/level_3/ears_ringing.mp3")
			await get_tree().create_timer(10).timeout
			node.stop()
			pass,
		2: func() -> void:
			await get_tree().create_timer(3).timeout
			TransitionManager.transition()
			pass,
		4: func() -> void:
		
	}
}

func _custom_sfx(audio: String) -> AudioStreamPlayer:
	var node = AudioStreamPlayer.new()
	node.bus = "SFX"
	node.stream = load(audio)
	add_child(node)
	node.play()
	return node

var cutscene_dialogue: Resource
var current_cutscene_number: int:
	get:
		return DataManager.Cutscene.current_cutscene_number
	set(value):
		DataManager.Cutscene.current_cutscene_number = value

var cutscene_data: CutsceneData
var current_title := 1

var is_end_mode: bool:
	get:
		return DataManager.Cutscene.is_end_mode
	set(value):
		DataManager.Cutscene.is_end_mode = value

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var dialogue_node: CutsceneDialogueBalloon
var dialogue_scene: PackedScene

func _ready() -> void:
	cutscene_data = get_cutscene(current_cutscene_number)
	cutscene_dialogue = load("res://dialogue/level_%s_cutscene.dialogue" % get_cutscene_item())
	
	dialogue_scene = load("res://dialogue/cutscene_dialogue/cutscene_dialogue.tscn") as PackedScene
	Music.play_music("res://audio/cutscene/cutscene_%s.mp3" % get_cutscene_item())
	
	_on_title_changed()
	_show_scene()
	DialogueManager.dialogue_ended.connect(
		_on_dialogue_ended
	)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	current_title += 1
	if (not (current_title > cutscene_data.max_page)):
		_on_title_changed()
		_show_scene()
	else:
		if (is_end_mode):
			is_end_mode = false
			current_cutscene_number += 1
		else:
			is_end_mode = true
		
		SceneManager.goto_scene(cutscene_data.end_scene)

func get_cutscene_item() -> String:
	var suffix: String = ""
	
	if (is_end_mode):
		suffix = "_end"
	else:
		suffix = ""
	
	return str(current_cutscene_number) + suffix

func _show_scene() -> void:
	texture_rect.texture = load("res://art/cutscenes/scene%s/0%s.png" % [get_cutscene_item(), current_title])
	dialogue_node = DialogueManager.show_dialogue_balloon_scene(dialogue_scene.instantiate(), cutscene_dialogue, "scene_" + str(current_title))

func _on_title_changed() -> void:
	$Timer.stop()
	$Timer.start()
	# stop audio
	audio_stream_player.stop()
	
	var index = (current_cutscene_number * 2) - 2
	if (is_end_mode):
		index += 1
	
	if mutations.has(index) and mutations[index].has(current_title):
		var function: Callable = mutations[index][current_title]
		function.call()
	
	if audio_map.has(index) and audio_map[index].has(current_title):
		audio_stream_player.stream = load(audio_map[index][current_title])
		audio_stream_player.play()


func _on_timer_timeout() -> void:
	if is_instance_valid(dialogue_node):
		dialogue_node.dialogue_line = null
		_on_dialogue_ended(null)
		$Timer.start()
