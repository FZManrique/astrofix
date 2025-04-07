class_name GUI
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var help_button: Button = $Statistics/HelpContainer/HelpButton
@onready var sub_viewport: SubViewport = %SubViewport

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
			DataManager.show_instruction_box = true
	)

func _process(_delta: float) -> void:
	if player_node != null:
		camera_node.position = player_node.position
