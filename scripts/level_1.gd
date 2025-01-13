extends Node2D

@onready var control: Control = $Characters/Player/Camera/Control
@onready var goal: Label = $Characters/Player/Camera/Goal

func _ready() -> void:
	control.display_msg("Oh no! I ran out of fuel, so I had to do an emergency landing on this planet. Looks like I'll need to find a fuel tank.")
	goal.text = "Goal: Find Fuel"

func _on_astronaut_on_npc_touch() -> void:
	control.display_msg("Hello, stranger! You seem exhausted. Luckily, I have a key right here. Not sure what this is for, but you can have it.")
	goal.text = "Goal: Unlock Fuel"
	Globals.add_item_to_inventory("key", 1)

func _on_fuel_tank_no_key() -> void:
	control.display_msg("Player: This fuel tank seems to be locked. Looks like I'll need a key. The opening on the left might be a good place to start looking for one...")
	goal.text = "Goal: Find Key"

func _on_fuel_tank_fuel_collected() -> void:
	control.display_msg("Level 1 Complete. Press \"DISMISS\" to quit.")
	goal.text = "GAME COMPLETE!!!"
	Globals.game_done = true

func _on_music_finished() -> void:
	$Music.play()

func _on_maze_start_body_entered(body: Node2D) -> void:
	if (body == $Characters/Player):
		control.display_msg("Looks like this planet has very tall mountains. I can't traverse these! I'll navigate to what looks like a maze ahead.")
		$"Characters/Maze Start".queue_free()
