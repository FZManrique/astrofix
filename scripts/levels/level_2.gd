extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	DataManager.Level2.wind_push = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	DataManager.Level2.wind_push = false
