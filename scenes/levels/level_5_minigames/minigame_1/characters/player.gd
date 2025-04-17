extends CharacterBody2D

@onready var audio_stream_player: AudioStreamPlayer = $Footsteps

const SPRINT_MULTIPLIER := 1.5
const ACCELERATION_SPEED := 8
const DECELERATION_SPEED := 6

@export var default_speed: float = 120
@export var sprint_speed: float = default_speed * SPRINT_MULTIPLIER
@export var speed: float = default_speed

var direction: Vector2
var isMoving := false

func _process(delta: float) -> void:
	if (isMoving):
		if (not audio_stream_player.playing):
			audio_stream_player.play()
	else:
		audio_stream_player.stop()

func _unhandled_input(event: InputEvent) -> void:
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

func _physics_process(delta: float):
	var target_speed: float = 0.0
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("ui_sprint"):
			target_speed = sprint_speed
		else:
			target_speed = default_speed
	else:
		target_speed = 0.0
	
	if direction != Vector2.ZERO:
		speed = lerp(speed, target_speed, ACCELERATION_SPEED * delta)
	else:
		speed = lerp(speed, target_speed, DECELERATION_SPEED * delta)

	var movement := (speed * direction * delta) as Vector2
	
	if not (GameStateManager.in_dialogue or GameStateManager.in_cutscene):
		if (direction != Vector2.ZERO):
			isMoving = true
			move_and_collide(movement)
		else:
			isMoving = false
	else:
		isMoving = false
