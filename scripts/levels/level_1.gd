extends Node2D

var dialogue: Resource = preload("res://dialogue/level_1.dialogue")

@export var level_resource: LevelResource = GameStateManager.levels.get("Neptune")

@onready var player: CharacterBody2D = $Characters/Player
@onready var instruction_box: InstructionBox = $CanvasLayer/InstructionBox

const Screen := preload("res://scripts/screens/gui/gui.gd")
const InstructionBox := preload("res://scripts/screens/instruction_box.gd")

func _ready() -> void:
	DataManager.intro_done = false
	GameStateManager.start_level(level_resource.level_id, level_resource)
	
	Music.play_music("res://audio/music/level_1.wav")
	OxygenManager.oxygen_depleted.connect(
		_on_oxygen_depleted
	)
	InventoryManager.item_added.connect(
		func(item: String, _count: int) -> void:
			if item == "key":
				$Characters/Key.queue_free()
			elif item == "fuel":
				GameStateManager.current_level.flag_bool[&"has_fuel"] = true
	)
	
	instruction_box.instruction_box_dismissed.connect(
		func() -> void:
			if (!DataManager.intro_done):
				DataManager.intro_done = true
				_show_dialoague_box("intro")
				await DialogueManager.dialogue_ended
				DatabaseManager.unlock_item_by_name("Neptune") 
	)
	
	for icicle: Icicle in $Icicles.get_children():
		icicle.on_player_hit.connect(
			func() -> void:
				($CanvasLayer/Screen as Screen).take_damage()
		)
	
	instruction_box.show_instruction_box()

func _process(_delta: float) -> void:
	if GameStateManager.current_level.flag_bool[&"should_move_william_to_ship"] and not GameStateManager.current_level.flag_bool[&"william_moved_to_ship"]:
		var william: Node2D = $Characters/William as Node2D
		william.global_position = Vector2(1366, 543)
		GameStateManager.current_level.flag_bool[&"william_moved_to_ship"] = true

#region Reations
func _on_spaceship_body_entered(body: Node2D) -> void:
	if (body == player):
		if (!GameStateManager.current_level.flag_bool[&"has_fuel"]):
			_show_dialoague_box("enter_ship_no_fuel")
		else:
			_show_dialoague_box("enter_ship_with_fuel")
			await DialogueManager.dialogue_ended
			if (GameStateManager.current_level.finished_level):
				return
			GameStateManager.complete_level()
			
			InventoryManager.remove_item_from_inventory("fuel", 1)
			GameStateManager.current_cutscene = preload("res://cutscenes/data/level_1_end.tres")
			SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")

func _on_fuel_tank_no_key() -> void:
	_show_dialoague_box("fuel_tank_locked")
	GoalManager.go_to_next_goal(1)
	await DialogueManager.dialogue_ended
	DatabaseManager.unlock_item_by_name("Fuel") 

func _on_key_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box("collect_key")
		GoalManager.go_to_next_goal(2)
		await DialogueManager.dialogue_ended
		DatabaseManager.unlock_item_by_name("William Shakesphere")

func _on_fuel_tank_fuel_collected() -> void:
	_show_dialoague_box("fuel_collected")
	GoalManager.go_to_next_goal(3)
	
	InventoryManager.remove_item_from_inventory("key", 1)
	InventoryManager.add_item_to_inventory("fuel", 1)

var done := false
func _on_oxygen_depleted() -> void:
	if (done): return
	done = true
	GameStateManager.fail_game(
		func() -> void:
			InventoryManager._clear_inventory()
			OxygenManager.reset_timer()
			
			SceneManager.goto_scene("res://scenes/levels/level_1.tscn")
	)
#endregion
	
func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialogue, key)
