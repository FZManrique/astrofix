extends CharacterBody2D

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $Footsteps

const SPRINT_MULTIPLIER := 1.5
const ACCELERATION_SPEED := 8
const DECELERATION_SPEED := 6

@export var default_speed: float = 120
@export var sprint_speed: float = default_speed * SPRINT_MULTIPLIER
@export var speed: float = default_speed

var isMoving := false

var new_direction := Vector2(0, 1)
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

	var target_speed: float = 0.0
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("ui_sprint"):
			target_speed = sprint_speed
		else:
			target_speed = default_speed
	else:
		target_speed = 0.0

	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		speed = lerp(speed, target_speed, ACCELERATION_SPEED * delta)
	else:
		speed = lerp(speed, target_speed, DECELERATION_SPEED * delta)

	var direction_resistance := get_wind_direction_resistance()

	var movement := (speed * (direction - direction_resistance) * delta) as Vector2

	if (not SceneManager.is_dialogue_shown):
		if (direction != Vector2.ZERO):
			isMoving = true
			move_and_collide(movement)
		else:
			isMoving = false
	else:
		isMoving = false
		
	player_animations(direction)

func get_wind_direction_resistance() -> Vector2:
	var wind_direction = DataManager.WIND_DIRECTION
	var wind_speed = DataManager.Level2.wind_speed
	
	var wind_resistances: Dictionary[DataManager.WIND_DIRECTION, Vector2] = {
		wind_direction.TO_TOP: Vector2(0, wind_speed),
		wind_direction.TO_BOTTOM: Vector2(0, -wind_speed),
		wind_direction.TO_LEFT: Vector2(-wind_speed, 0),
		wind_direction.TO_RIGHT: Vector2(wind_speed, 0),
	}

	if (DataManager.Level2.wind_push):
		return wind_resistances.get(DataManager.Level2.wind_direction, Vector2.ZERO)
	
	return Vector2.ZERO

func player_animations(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "v2_walk_" + returned_direction(new_direction)
	else:
		animation  = "v2_idle_" + returned_direction(new_direction, true)
	
	animation_sprite.play(animation)

func returned_direction(direction: Vector2, hasStopped: bool = false) -> StringName:
	var normalized_direction  = direction.normalized()

	if normalized_direction.y > 0: return "down"
	elif normalized_direction.y < 0: return "up"
	elif normalized_direction.x > 0:
		if (hasStopped): return "left"
		return "right"
	elif normalized_direction.x < 0:
		if (hasStopped): return "right"
		return "left"

	# Default to down
	return "down"
