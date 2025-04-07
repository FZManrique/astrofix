class_name SpaceSpam
extends Control

@onready var progress_bar: ProgressBar = $ColorRect/Panel/VBoxContainer/ProgressBar

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		progress_bar.value += 5

var test := 0
func _process(delta: float) -> void:
	if (progress_bar.value == 100):
		queue_free()
		DialogueManager.show_dialogue_balloon(load("res://dialogue/level_1.dialogue"), "end_level")
		return
	
	test += 1
	if (test == 10):
		progress_bar.value -= 1
		test = 0

func _on_timer_timeout() -> void:
	SceneManager.fail_game(
		func() -> void:
			SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_2/minigame_2.tscn")
	)
