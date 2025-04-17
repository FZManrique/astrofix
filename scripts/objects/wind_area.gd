class_name WindArea
extends Area2D

signal on_enter
signal on_exit

@export var wind_direction: Level2Resource.WindDirection
@export var wind_speed: int = 40

@onready var current_level_data: Level2Resource = GameStateManager.current_level

func _on_body_entered(body: Node2D) -> void:
	on_enter.emit()
	current_level_data.wind_direction = wind_direction
	current_level_data.wind_speed = wind_speed
	current_level_data.wind_push = true

func _on_body_exited(body: Node2D) -> void:
	on_exit.emit()
	current_level_data.wind_push = false
