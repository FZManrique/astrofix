extends Area2D

signal oxygen_tank_collected

func _on_body_entered(body):
	oxygen_tank_collected.emit()
	queue_free()
