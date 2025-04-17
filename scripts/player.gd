extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx: AudioStreamPlayer = $Footsteps

const SPRINT_MULT := 1.5
@export var walk_speed := 120.0

var last_dir := Vector2.DOWN

func _physics_process(delta: float) -> void:
	if GameStateManager.in_cutscene or GameStateManager.in_dialogue:
		sfx.stop()
		sprite.play("v2_idle_" + dir_name(last_dir))
		return

	var input := input_direction()
	var speed := walk_speed * (SPRINT_MULT if Input.is_action_pressed("ui_sprint") else 1.0)
	var wind := get_wind_push()

	var velocity := (input * speed) - wind
	move_and_collide(velocity * delta)

	update_state(input, velocity)

func input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

func get_wind_push() -> Vector2:
	var data := GameStateManager.current_level as Level2Resource
	if not data or not data.wind_push: return Vector2.ZERO

	var w := data.wind_speed
	match data.wind_direction:
		data.WindDirection.TO_TOP: return Vector2(0, w)
		data.WindDirection.TO_BOTTOM: return Vector2(0, -w)
		data.WindDirection.TO_LEFT: return Vector2(-w, 0)
		data.WindDirection.TO_RIGHT: return Vector2(w, 0)
	return Vector2.ZERO

func update_state(input: Vector2, velocity: Vector2) -> void:
	var moving := input != Vector2.ZERO or velocity.length() > 5.0

	if moving:
		if not sfx.playing: sfx.play()
		if input != Vector2.ZERO:
			last_dir = input
			sprite.play("v2_walk_" + dir_name(last_dir))
		else:
			sprite.play("v2_idle_" + dir_name(last_dir))
	else:
		sfx.stop()
		sprite.play("v2_idle_" + dir_name(last_dir))

func dir_name(dir: Vector2) -> StringName:
	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	elif abs(dir.y) > 0:
		return "down" if dir.y > 0 else "up"
	return "down"
