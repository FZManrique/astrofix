extends Node2D

var died := false

const Screen := preload("res://scripts/screens/gui/gui.gd")
const InstructionBox := preload("res://scripts/screens/instruction_box.gd")

@export var level_resource: LevelResource = GameStateManager.levels.get("Jupiter")

@onready var instruction_box: InstructionBox = $CanvasLayer/InstructionBox
@onready var current_level_data: LevelResource = GameStateManager.current_level

func _ready() -> void:
	GameStateManager.start_level(level_resource.level_id, level_resource)
	
	Music.change_db(0)
	Music.play_music("res://audio/music/level_4.mp3")
	DataManager.intro_done = false
	GoalManager.go_to_next_goal(9)
	
	OxygenManager.oxygen_depleted.connect(
		func() -> void:
			if (not died):
				died = true
				GameStateManager.fail_game(
					func() -> void:
						InventoryManager._clear_inventory()
						OxygenManager.reset_timer()
						SceneManager.goto_scene("res://scenes/levels/level_4.tscn")
				)
	)
	
	DataManager.Level4_has_done_confrontation.connect(
		func() -> void:
			const Level4Minigame := preload("res://scenes/levels/level_4_minigame/minigame.gd")
			var minigame := preload("res://scenes/levels/level_4_minigame/minigame.tscn") as PackedScene
			var minigame_node: Level4Minigame = minigame.instantiate()
			
			add_child(minigame_node)
			minigame_node.on_dismiss.connect(
				func():
					_show_dialoague_box("ending")
					await DialogueManager.dialogue_ended
					if (current_level_data.finished_level):
						return
					GameStateManager.complete_level()
					GameStateManager.current_cutscene = preload("res://cutscenes/data/level_4_end.tres")
					SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")
			)
	)
	
	instruction_box.instruction_box_dismissed.connect(
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
				await DialogueManager.dialogue_ended
				DatabaseManager.unlock_item_by_name("Jupiter")
	)
	
	for spike in \
		($Tilemap/Decorations/Medium/Type1.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Medium/Type2.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Large/Type1.get_children() as Array[Spike]) + \
		($Tilemap/Decorations/Large/Type2.get_children() as Array[Spike]):
		spike.player_hit.connect(
			func() -> void:
				($CanvasLayer/Screen as Screen).take_damage()
		)
	
	%Shards.process_mode = Node.PROCESS_MODE_DISABLED
	%Shards.hide()
	
	instruction_box.show_instruction_box()

func _on_conny_body_entered(body: Node2D) -> void:
	if (current_level_data.flag_bool[&"talked_to_conny"]):
		if (current_level_data.flag_int[&"crystal_count"] == 4):
			if (current_level_data.flag_bool[&"talked_after_most_crystals"]):
				_show_dialoague_box("uncertain")
			else:
				_show_dialoague_box("discussion")
		else:
			_show_dialoague_box("already_talked")
	else:
		_show_dialoague_box("initial_talk")
		await DialogueManager.dialogue_ended
		%Shards.process_mode = Node.PROCESS_MODE_INHERIT
		%Shards.show()
		DatabaseManager.unlock_item_by_name("Sailor Conn")
		GoalManager.go_to_next_goal(10)


func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(preload("res://dialogue/level_4.dialogue"), key)
