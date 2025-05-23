extends Control

const InstructionBox := preload("res://scripts/screens/instruction_box.gd")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var help_button: Button = $Statistics/HelpContainer/HelpButton
@onready var sub_viewport: SubViewport = %SubViewport

@export var instruction_box_node: InstructionBox
@export var camera_node: Node2D
@export var player_node: Node2D

func take_damage(count: int = 1) -> void:
	for i in count:
		animation_player.play("damage")
		await animation_player.animation_finished

func _ready() -> void:
	sub_viewport.world_2d = get_tree().root.world_2d
	help_button.pressed.connect(
		func() -> void:
			instruction_box_node.show_instruction_box()
	)

func _process(_delta: float) -> void:
	if player_node != null:
		camera_node.position = player_node.position
