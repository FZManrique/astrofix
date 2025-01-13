extends Area2D

signal fuel_collected
signal no_key

func _on_body_entered(body: Node2D) -> void:
	if (Globals.inventory.get("key") == 1):
		fuel_collected.emit()
		queue_free()
	else:
		no_key.emit()
