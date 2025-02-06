extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	Settings.wind_push = 60


func _on_area_2d_body_exited(body: Node2D) -> void:
	Settings.wind_push = 0
