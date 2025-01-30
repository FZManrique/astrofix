extends Node2D

var dialog = load("res://dialogue/level1.dialogue")

@onready var goal: RichTextLabel = $Screen/Panel/Goal
@onready var player: CharacterBody2D = $Characters/Player
@onready var maze_start: Area2D = $"Characters/Maze Start"
@onready var inventory: Label = $Screen/Inventory
@onready var oxygen_handler: Control = $Screen/Panel/OxygenHandler

func _ready() -> void:
	Music.play_music("res://soundtrack/music/level1.wav")
	OxygenManager.connect("oxygen_depleted", _on_oxygen_depleted)
	_show_dialoague_box("intro")
	goal.change_goal("Find Fuel")

func _process(delta: float) -> void:
	if (SceneManager.is_dialogue_shown):
		OxygenManager.pause_timer()
	else:
		OxygenManager.start_timer()

func _on_spaceship_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box("enter_ship")

func _on_fuel_tank_no_key() -> void:
	_show_dialoague_box("fuel_tank_locked")
	goal.change_goal("Find Key")

func _on_maze_start_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box( "maze_look")
		maze_start.queue_free()


func _on_astronaut_body_entered(body: Node2D) -> void:
	if (body == player):
		_show_dialoague_box( "collect_key")
		goal.change_goal("Unlock Fuel")
		InventoryManager.add_item_to_inventory("key", 1)
		inventory.text = "Inv: Key (1)"

func _on_fuel_tank_fuel_collected() -> void:
	_show_dialoague_box("end_level")
	OxygenManager.pause_timer()
	goal.clear_goals()
	inventory.text = ""
	
	DialogueManager.dialogue_ended.connect(
		_exit_game
	)

func _show_dialoague_box(key: String) -> void:
	DialogueManager.show_dialogue_balloon(dialog, key)

func _exit_game(_pass):
	print("Exiting...")
	get_tree().quit() 


func _on_oxygen_tank_oxygen_tank_collected(amount) -> void:
	OxygenManager.add_oxygen(amount)

func _on_oxygen_depleted() -> void:
	Music.stop_music()
	$FailSFX.play()

	DialogueManager.show_dialogue_balloon(dialog, "failed")
	DialogueManager.dialogue_ended.connect(
		_restart
	)

func _restart(_pass) -> void:
	get_tree().reload_current_scene() 
