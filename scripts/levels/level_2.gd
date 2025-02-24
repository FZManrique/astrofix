extends Node2D

var dialog = load("res://dialogue/level2.dialogue")

func _ready() -> void:
	DialogueManager.show_dialogue_balloon(dialog, "intro")
