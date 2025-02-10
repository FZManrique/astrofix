extends Area2D

signal fuel_collected
signal no_key

func _on_body_entered(body: Node2D) -> void:
	if (InventoryManager.inventory.get("key") == 1):
		fuel_collected.emit()
		$AnimationPlayer.play("pickup")
	else:
		no_key.emit()
