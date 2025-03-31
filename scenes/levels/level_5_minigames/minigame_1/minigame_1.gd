extends Node2D

@onready var enemy: CharacterBody2D = %Enemy
@onready var player: CharacterBody2D = %Player
@onready var timer_label: Label = $CanvasLayer/GUI/HBoxContainer/TimerContainer/Timer

@onready var bombs: Node2D = $NavigationRegion2D/Bombs
@onready var timers: Node2D = $NavigationRegion2D/Timers

const TIMER_INCREASE := 10

var time_limit := 180

func _ready() -> void:
	start_timer()
	
	for bomb in bombs.get_children() as Array[Bomb]:
		bomb.on_bomb_hit.connect(
			func() -> void:
				game_over()
		)
	
	for timer_powerup in timers.get_children() as Array[TimerPowerup]:
		timer_powerup.on_timer_powerup_entered.connect(
			func() -> void:
				time_limit += TIMER_INCREASE
		)
	
	
func start_timer() -> void:
	var timer := Timer.new()
	timer.wait_time = 1
	timer.timeout.connect(
		func() -> void:
			time_limit -= 1
			timer_label.text = "Time left: " + str(time_limit) + "s"
			if time_limit <= 0:
				game_over()
	)
	add_child(timer)
	timer.start()

func game_over() -> void:
	SceneManager.fail_game(
		func() -> void:
			SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_1/minigame_1.tscn")
	)

func _on_hit_player() -> void:
	game_over()

func _on_enter_true_exit(body: Node2D) -> void:
	pass # Replace with function body.
