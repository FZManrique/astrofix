extends StaticBody2D

@export var player: CharacterBody2D

# add icicle oxygen decrease
func _ready() -> void:
	$Area2D.body_entered.connect(
		func(body: Node2D):
			if (!DataManager.Level1.has_hit_spikes):
				DialogueManager.show_dialogue_balloon(
					load("res://dialogue/level_1.dialogue"),
					"hit_spikes"
				)
				DataManager.Level1.has_hit_spikes = true
			OxygenManager.remove_oxygen(5)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
