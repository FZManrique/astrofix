extends Area2D

signal on_npc_touch()

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		on_npc_touch.emit()
