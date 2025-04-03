class_name TimerAccuracy
extends Control

@onready var timer: Timer = $Timer
@onready var green: TextureRect = %Green
@onready var hand: TextureRect = %Hand
@onready var green_area: Area2D = $ColorRect/VBoxContainer/VBoxContainer/Minigame/Control/Green/GreenArea
@onready var hand_area: Area2D = $ColorRect/VBoxContainer/VBoxContainer/Minigame/Control/Hand/HandArea

signal correct
signal wrong
signal game_done

signal on_run
signal on_stop

var green_rotation: int = 0
var hand_rotation: int = 0

var temp_should_run := false
var should_run: bool:
	get:
		return temp_should_run
	set(value):
		temp_should_run = value
		if (temp_should_run):
			on_run.emit()
		else:
			on_stop.emit()


var is_inside := false

func _ready() -> void:
	green_area.area_entered.connect(
		func(_area: Area2D) -> void:
			is_inside = true
	)
	green_area.area_exited.connect(
		func(_area: Area2D) -> void:
			is_inside = false
	)
	on_run.connect(
		func() -> void:
			timer.start()
			timer.timeout.connect(check)
	)
	on_stop.connect(
		func() -> void:
			timer.timeout.disconnect(check)
			timer.stop()
	)

func check_if_correct() -> void:
	if (is_inside):
		correct.emit()
	else:
		wrong.emit()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		check()

func _process(delta: float) -> void:
	(%Objectives as Label).text = "Time left: " + str(roundf(timer.time_left)) + "s"

func _physics_process(_delta: float) -> void:
	if (should_run):
		hand_rotation += 5
		if hand_rotation > 360:
			hand_rotation = 0
		
	%Hand.rotation_degrees = hand_rotation

func setup() -> void:
	should_run = true
	green_rotation = randi_range(0, 360)
	green.rotation_degrees = green_rotation

func check() -> void:
	if (!should_run):
		return
	
	should_run = false
	
	await get_tree().create_timer(0.5).timeout
	check_if_correct()
	game_done.emit()
