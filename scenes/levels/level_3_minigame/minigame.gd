extends Node2D

func _ready() -> void:
	OxygenManager.oxygen_depleted.connect(
		func():
			SceneManager.fail_game(Level3.on_restart)
	)
	
	if (DataManager.Level3.in_asteroid_area):
		%Player.position = Vector2(2152.0, 244.0)
	else:
		%Player.position = Vector2(174.0, 378)

func _on_to_planet_body_entered(body: Node2D) -> void:
	DataManager.Level3.in_asteroid_area = false
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")

func _on_to_asteroid_body_entered(body: Node2D) -> void:
	DataManager.Level3.in_asteroid_area = true
	SceneManager.goto_scene("res://scenes/levels/level_3.tscn")

func _on_killzone_body_entered(body: Node2D) -> void:
	SceneManager.fail_game(
		func() -> void:
			Level3.on_restart()
	)
