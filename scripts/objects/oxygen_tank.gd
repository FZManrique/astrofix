extends Area2D

@export var oxygen_increase = 30

signal oxygen_tank_collected(amount)

func _on_body_entered(body):
	oxygen_tank_collected.emit(oxygen_increase)
	$AnimationPlayer.play("pickup")
