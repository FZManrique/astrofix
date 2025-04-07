class_name Bomb
extends Area2D

@export var player_body: CharacterBody2D

signal on_bomb_hit

func _on_body_entered(body: Node2D) -> void:
	if (body == player_body):
		on_bomb_hit.emit()
		$AudioStreamPlayer.play(1.94)
		hide()
		await get_tree().create_timer(10).timeout
		queue_free()
	else:
		modulate.a = 0.5

func _on_body_exited(_body: Node2D) -> void:
	modulate.a = 1
