class_name TimerPowerup
extends Area2D

signal on_timer_powerup_entered

func _on_body_entered(body: Node2D) -> void:
	on_timer_powerup_entered.emit()
	queue_free()
