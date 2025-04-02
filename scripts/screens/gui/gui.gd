extends Control

@onready var sub_viewport: SubViewport = %SubViewport

func _ready() -> void:
	sub_viewport.world_2d = get_tree().root.world_2d

@export var camera_node : Node2D
@export var player_node : Node2D

func _process(_delta: float) -> void:
	# Let camera move with player
	if player_node != null:
		camera_node.position = player_node.position

func _on_help_button_pressed() -> void:
	DataManager.show_instruction_box = true
