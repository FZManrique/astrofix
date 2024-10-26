extends CharacterBody2D

@export var speed = 50.0
@onready var animation_sprite = $AnimatedSprite2D

var new_direction = Vector2(0, 1)
var animation: StringName

func _physics_process(delta: float):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	var movement = speed * direction * delta
	move_and_collide(movement)
	player_animations(direction)

func player_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		animation  = "idle_" + returned_direction(new_direction)
		animation_sprite.play(animation)

func returned_direction(direction : Vector2):
	var normalized_direction  = direction.normalized()
	var default_return = "side"

	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"

	#default value is empty
	return default_return
