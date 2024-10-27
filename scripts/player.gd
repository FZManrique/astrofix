extends CharacterBody2D

@export var speed = 50.0
@onready var animation_sprite = $AnimatedSprite2D

var new_direction = Vector2(0, 1)
var animation: StringName

func _physics_process(delta: float):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Sprinting          
	if Input.is_action_pressed("ui_sprint"):
		speed = 100
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50  

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

func returned_direction(direction: Vector2) -> StringName:
	var normalized_direction  = direction.normalized()

	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		# Right direction
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		# Left direction; we flip the image for reusability
		$AnimatedSprite2D.flip_h = true
		return "side"

	# Default to side
	return "side"
	
	# midway in https://dev.to/christinec_dev/lets-learn-godot-4-by-making-an-rpg-part-1-project-overview-setup-bgc
	# https://docs.google.com/document/d/1486cjDI0bCL2c9y1RodzRv4qfyuKHxLhHe7jht0C744/edit?tab=t.0
	# todo: download assets
