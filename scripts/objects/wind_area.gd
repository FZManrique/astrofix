class_name WindArea
extends Area2D

signal on_enter
signal on_exit

@export var wind_direction: DataManager.WIND_DIRECTION
@export var wind_speed: int = 40

func _on_body_entered(body: Node2D) -> void:
	on_enter.emit()
	DataManager.Level2.wind_direction = wind_direction
	DataManager.Level2.wind_speed = wind_speed
	DataManager.Level2.wind_push = true

func _on_body_exited(body: Node2D) -> void:
	on_exit.emit()
	DataManager.Level2.wind_push = false
