class_name Spike
extends Sprite2D

signal player_hit

func _ready() -> void:
	var area_2d: Area2D = get_node_or_null("Area2D")
	if not area_2d: return
	area_2d.body_entered.connect(
		func(body: Node2D):
			OxygenManager.remove_oxygen(5)
			player_hit.emit()
	)
