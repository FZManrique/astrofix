class_name Icicle
extends StaticBody2D

@export var player: CharacterBody2D

signal on_player_hit

# add icicle oxygen decrease
func _ready() -> void:
	($Area2D as Area2D).body_entered.connect(
		func(_body: Node2D) -> void:
			on_player_hit.emit()
			if (!GameStateManager.current_level.flag_bool[&"has_hit_spikes"]):
				DialogueManager.show_dialogue_balloon(
					preload("res://dialogue/level_1.dialogue") as DialogueResource,
					"hit_spikes"
				)
				GameStateManager.current_level.flag_bool[&"has_hit_spikes"] = true
			OxygenManager.remove_oxygen(5)
	)
