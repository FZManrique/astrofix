extends Node2D

var dialog = load("res://dialogue/level1.dialogue")
var Level1Data = DataManager.Level1

@onready var player: CharacterBody2D = $Characters/Player
@onready var maze_start: Area2D = $"Characters/Maze Start"

func _ready() -> void:
	Music.play_music("res://audio/music/level_1.wav")
	OxygenManager.connect(
		"oxygen_depleted",
		_on_oxygen_depleted
	)
	InventoryManager.connect(
		"item_added", _on_item_added
	)
	_show_dialoague_box("intro")

func _process(delta: float) -> void:
	if (Level1Data.should_move_william_to_ship and (not Level1Data.william_moved_to_ship)):
		var william = $Characters/William
		william.global_position = Vector2(1366, 543)
		Level1Data.william_moved_to_ship = true

func _on_item_added(item, _count) -> void:
	if (item == "key"):
		$Characters/Key.queue_free()
	
	if (item == "fuel"):
		Level1Data.has_fuel = true

#region Reations
func _on_spaceship_body_entered(body: Node2D) -> void:
	if (body == player):
		if (!Level1Data.has_fuel):
			_show_dialoague_box("enter_ship_no_fuel")
		else:
			_show_dialoague_box("enter_ship_with_fuel")
			DialogueManager.dialogue_ended.connect(
				_go_to_level_2
			)

func _on_fuel_tank_no_key() -> void:
	_show_dialoague_box("fuel_tank_locked")
	GoalManager.go_to_next_goal(1)

func _on_maze_start_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box("maze_look")
		maze_start.queue_free()

func _on_key_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box("collect_key")
		GoalManager.go_to_next_goal(2)

func _on_fuel_tank_fuel_collected() -> void:
	_show_dialoague_box("fuel_collected")
	GoalManager.go_to_next_goal(3)
	
	InventoryManager.remove_item_from_inventory("key", 1)
	InventoryManager.add_item_to_inventory("fuel", 1)


func _on_oxygen_tank_oxygen_tank_collected(amount: int) -> void:
	OxygenManager.add_oxygen(amount)

func _on_oxygen_depleted() -> void:
	Music.stop_music()
	$FailSFX.play()

	DialogueManager.show_dialogue_balloon(dialog, "failed")
	DialogueManager.dialogue_ended.connect(
		_restart
	)
#endregion
	
func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialog, key)

#region Functions
func _go_to_level_2(_pass) -> void:
	SceneManager.goto_scene("res://scenes/levels/level_2.tscn")

func _restart(_pass) -> void:
	InventoryManager._clear_inventory()
	OxygenManager.reset_timer()
	SceneManager.goto_scene("res://scenes/levels/level_1.tscn")
#endregion
