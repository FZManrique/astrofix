extends Area2D

signal fuel_collected
signal no_key
	
func force_pickup() -> void:
	$AnimationPlayer.play("pickup")

func _on_body_entered(_body: Node2D) -> void:
	if (InventoryManager.inventory.get("key") == 1):
		fuel_collected.emit()
		$AnimationPlayer.play("pickup")
	else:
		no_key.emit()
