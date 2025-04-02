extends Control

@onready var green: TextureRect = %Green
@onready var hand: TextureRect = %Hand
@onready var green_area: Area2D = $ColorRect/VBoxContainer/VBoxContainer/Minigame/Control/Green/GreenArea
@onready var hand_area: Area2D = $ColorRect/VBoxContainer/VBoxContainer/Minigame/Control/Hand/HandArea

var correct_rotation: int = 0
var should_run := false
var is_inside := false
var degrees: int = 0

func _ready() -> void:
	setup()
	green_area.area_entered.connect(
		func(_area: Area2D) -> void:
			is_inside = true
	)
	green_area.area_exited.connect(
		func(_area: Area2D) -> void:
			is_inside = false
	)

func check_if_correct() -> void:
	if (is_inside):
		(%Objectives as Label).text = "Correct!"
	else:
		(%Objectives as Label).text = "Failed!"

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		if (!should_run):
			return
		
		should_run = false
		
		check_if_correct()
		await get_tree().create_timer(2).timeout
		(%Objectives as Label).text = "Click when arrow is in green"
		
		setup()

func _physics_process(_delta: float) -> void:
	if (should_run):
		degrees += 5
		if degrees > 360:
			degrees = 0
		
	%Hand.rotation_degrees = degrees

func setup() -> void:
	should_run = true
	correct_rotation = randi_range(0, 360)
	green.rotation_degrees = correct_rotation
