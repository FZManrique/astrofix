class_name MediumSpike
extends Sprite2D

func _ready() -> void:
	$Area2D.body_entered.connect(
		func(body: Node2D):
			OxygenManager.remove_oxygen(5)
	)
