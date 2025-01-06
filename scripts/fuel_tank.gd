extends Area2D

signal fuel_collected
signal no_key

@onready var globals: Globals = %Globals

func _on_body_entered(body: Node2D) -> void:
	if (globals.inventory.get("key") == 1):
		fuel_collected.emit()
		queue_free()
	else:
		no_key.emit()
