extends CharacterBody2D


const SPEED = 100
const GRAVITY = Vector2(0, 120)
const JUMP_VELOCITY = -100

@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0

var animation: StringName
var new_direction: float = 0
@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	var velocity_change_speed: float = 0.0
	if is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, velocity_change_speed)

	move_and_slide()
	player_animations(direction)

func player_animations(direction: float) -> void:
	if not is_on_floor() && direction != 0:
		animation = "jump_" + returned_direction(direction)
		animation_sprite.play(animation)
		return
	
	if direction != 0:
		new_direction = direction
		animation = "v2_walk_" + returned_direction(direction)
		animation_sprite.play(animation)
	else:
		animation  = "v2_idle_" + returned_direction(new_direction, true)
		animation_sprite.play(animation)
		
func returned_direction(direction: float, hasStopped: bool = false) -> StringName:
	if direction > 0:
		if (hasStopped): return "left"
		return "right"
	else:
		if (hasStopped): return "right"
		return "left"
