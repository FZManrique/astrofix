extends StaticBody2D

# add icicle oxygen decrease
func _ready() -> void:
	$Area2D.connect("body_entered",
		func(body: Node2D):
			pass
			#if body is CharacterBody2D:
				#OxygenManager.remove_oxygen(5)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
