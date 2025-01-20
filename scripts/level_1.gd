extends Node2D

@onready var goal: RichTextLabel = $Screen/Panel/Goal

var dialog = load("res://dialogue/level1.dialogue")

func _ready() -> void:
	DialogueManager.show_dialogue_balloon(dialog, "intro")
	goal.change_goal("Find Fuel")
	DialogueManager.dialogue_ended.connect(
		_on_start_consume
	)
	
func _on_fuel_tank_no_key() -> void:
	DialogueManager.show_dialogue_balloon(dialog, "fuel_tank_locked")
	goal.change_goal("Find Key")

func _on_maze_start_body_entered(body: Node2D) -> void:
	if (body == $Characters/Player):
		DialogueManager.show_dialogue_balloon(dialog, "maze_look")
		$"Characters/Maze Start".queue_free()

func _on_astronaut_on_npc_touch() -> void:
	DialogueManager.show_dialogue_balloon(dialog, "collect_key")
	goal.change_goal("Unlock Fuel")
	Globals.add_item_to_inventory("key", 1)
	$Screen/Inventory.text = "Inv: Key (1)"

func _on_fuel_tank_fuel_collected() -> void:
	DialogueManager.show_dialogue_balloon(dialog, "end_level")
	goal.clear_goals()
	$Screen/Inventory.text = ""
	$Screen/Panel/OxygenHandler/Timer.stop()
	DialogueManager.dialogue_ended.connect(
		_exit_game
	)
	Globals.game_done = true

func _exit_game(_pass):
	print("Exiting...")
	get_tree().quit() 

func _on_music_finished() -> void:
	$Music.play()

func _on_start_consume(_pass) -> void:
	$Screen/Panel/OxygenHandler.on_start_deplete()

func _on_oxygen_tank_oxygen_tank_collected() -> void:
	$Screen/Panel/OxygenHandler.replenish_oxygen(30)
