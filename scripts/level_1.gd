extends Node2D

@onready var control: Control = $"Screen/Dialog Box"
@onready var goal: RichTextLabel = $Screen/Goal

func _ready() -> void:
	#var dialog = load("res://dialogue/intro.dialogue")
	#DialogueManager.show_dialogue_balloon(dialog, "this_is_a_node_title")
	control.show_dialog_box("Oh no! I ran out of fuel, so I had to do an emergency landing on this planet. Looks like I'll need to find a fuel tank.", "Let's explore!")
	goal.change_goal("Find Fuel")
	
func _on_fuel_tank_no_key() -> void:
	control.show_dialog_box("Player: This fuel tank seems to be locked. Looks like I'll need a key. The opening on the left might be a good place to start looking for one...", "Start looking for a key")
	goal.change_goal("Find Key")

func _on_astronaut_on_npc_touch() -> void:
	goal.change_goal("Listen to NPC")
	control.show_dialog_box("Hello, stranger! You seem exhausted. Luckily, I have a key right here. Not sure what this is for, but you can have it.", "Take key")
	goal.change_goal("Unlock Fuel")
	Globals.add_item_to_inventory("key", 1)
	$Screen/Inventory.text = "Inv: Key (1)"

func _on_fuel_tank_fuel_collected() -> void:
	control.show_dialog_box("Level 1 Complete. You may now exit the game", "Quit")
	goal.change_goal("Level complete!!!")
	$Screen/Inventory.text = ""
	Globals.game_done = true

func _on_music_finished() -> void:
	$Music.play()

func _on_maze_start_body_entered(body: Node2D) -> void:
	if (body == $Characters/Player):
		control.show_dialog_box("Looks like this planet has very tall mountains. I can't traverse these! I'll navigate to what looks like a maze ahead.", "Dismiss")
		$"Characters/Maze Start".queue_free()
