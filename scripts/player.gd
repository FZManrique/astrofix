extends CharacterBody2D

@onready var animation_sprite = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var default_speed = 75.0
@export var sprint_speed = default_speed * 2
@export var speed = default_speed

var isMoving: bool = false

var new_direction = Vector2(0, 1)
var animation: StringName

func _process(delta: float) -> void:
	if (isMoving):
		if (not audio_stream_player.playing):
			audio_stream_player.play()
	else:
		audio_stream_player.stop()

func _physics_process(delta: float):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Sprinting          
	if Input.is_action_pressed("ui_sprint"):
		speed = sprint_speed
	elif Input.is_action_just_released("ui_sprint"):
		speed = default_speed

	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	#if (Settings.wind_push != 0):
		#if (Input.is_action_pressed("ui_stop_wind")):
			#pass
		#else:
			#direction.x += 80 * delta
#
	#var movement = (speed - Settings.wind_push) * direction * delta
	
	var movement = speed * direction * delta

	if (not SceneManager.is_dialogue_shown):
		if (movement != Vector2.ZERO):
			isMoving = true
		else:
			isMoving = false

		move_and_collide(movement)
		player_animations(direction)
	else:
		isMoving = false
		player_animations(Vector2.ZERO)

func player_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "v2_walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		animation  = "v2_idle_" + returned_direction(new_direction, true)
		animation_sprite.play(animation)

func returned_direction(direction: Vector2, hasStopped: bool = false
) -> StringName:
	var normalized_direction  = direction.normalized()

	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		if (hasStopped): return "left"
		return "right"
	elif normalized_direction.x < 0:
		if (hasStopped): return "right"
		return "left"

	# Default to down
	return "down"
