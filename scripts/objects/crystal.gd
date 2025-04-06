extends Area2D

@export var image: Texture2D

var crystal_count: int:
	get:
		return DataManager.Level4.crystal_count
	set(value):
		DataManager.Level4.crystal_count = value

func _ready() -> void:
	$Sprite2D.texture = image

func _on_body_entered(body: Node2D) -> void:
	var resource = load("res://dialogue/level_4.dialogue")
	crystal_count += 1
	InventoryManager.add_item_to_inventory("crystal", 1)
	print(DataManager.Level4.crystal_count)
	
	if (crystal_count == 4):
		GoalManager.go_to_next_goal(11)
		DialogueManager.show_dialogue_balloon(resource, "last")
	else:
		DialogueManager.show_dialogue_balloon(resource, "motivation")
	
	$AnimationPlayer.play("pickup")
