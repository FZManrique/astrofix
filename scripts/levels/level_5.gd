extends Node2D

var Data := DataManager.Level5

func _ready() -> void:
	GoalManager.go_to_next_goal(13)

func _on_dan_area_body_entered(body: Node2D) -> void:
	_show_dialoague_box("talk_to_dan")
	await DialogueManager.dialogue_ended
	GoalManager.go_to_next_goal(14)
	SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_1/minigame_1.tscn")

func _show_dialoague_box(key: StringName) -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/level_5.dialogue"), key)
