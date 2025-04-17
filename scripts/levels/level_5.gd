extends Node2D

const InstructionBox := preload("res://scripts/screens/instruction_box.gd")
@onready var instruction_box: InstructionBox = $CanvasLayer/InstructionBox

@export var level_resource: LevelResource = GameStateManager.levels.get("Mars")
@onready var current_level_data: LevelResource = GameStateManager.current_level

@onready var dan: StaticBody2D = %Dan

signal show_dan

func _ready() -> void:
	GameStateManager.start_level(level_resource.level_id, level_resource)
	
	Music.play_music("res://audio/music/level_5.mp3")
	GoalManager.go_to_next_goal(13)
	DataManager.intro_done = false
	
	instruction_box.instruction_box_dismissed.connect(
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
				await DialogueManager.dialogue_ended
				DatabaseManager.unlock_item_by_name("Mars")
	)
	
	OxygenManager.oxygen_depleted.connect(
		func():
			GameStateManager.fail_game(
				func() -> void:
					InventoryManager._clear_inventory()
					OxygenManager.reset_timer()
					SceneManager.goto_scene("res://scenes/levels/level_5.tscn")
			)
	)
	
	DataManager.show_dan.connect(
		func() -> void:
			dan.process_mode = Node.PROCESS_MODE_INHERIT
			dan.show()
	)
	
	dan.process_mode = Node.PROCESS_MODE_DISABLED
	dan.hide()
	
	instruction_box.show_instruction_box()

func _on_dan_area_body_entered(body: Node2D) -> void:
	_show_dialoague_box("talk_to_dan")
	await DialogueManager.dialogue_ended
	GoalManager.go_to_next_goal(14)
	SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_1/minigame_1.tscn")

func _on_encounter_many_tanks_body_entered(body: Node2D) -> void:
	_show_dialoague_box("empty_canisters")
	await DialogueManager.dialogue_ended
	$Characters/EncounterManyTanks.queue_free()

func _show_dialoague_box(key: StringName) -> void:
	DialogueManager.show_dialogue_balloon(preload("res://dialogue/level_5.dialogue"), key)
