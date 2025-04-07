extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D

const SPEED := 80

signal on_player_hit
var has_hit_player := false

func _ready() -> void:
	set_physics_process(false)
	wait_for_physics.call_deferred()
	
func wait_for_physics() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if (SceneManager.is_dialogue_shown):
		return
	
	if (
		navigation_agent.is_navigation_finished() and target_to_chase.global_position.distance_to(navigation_agent.target_position) <= 25
	):
		if (!has_hit_player):
			has_hit_player = true
			on_player_hit.emit()
		return
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	move_and_slide()
