class_name TimerPowerup
extends Area2D

@export var player_body: CharacterBody2D

signal on_timer_powerup_entered

func _on_body_entered(body: Node2D) -> void:
	if (body == player_body):
		on_timer_powerup_entered.emit()
		$AudioStreamPlayer.play()
		hide()
		await $AudioStreamPlayer.finished
		queue_free()
	else:
		modulate.a = 0.5


func _on_body_exited(_body: Node2D) -> void:
	modulate.a = 1
