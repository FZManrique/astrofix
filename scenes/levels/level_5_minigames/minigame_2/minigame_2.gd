extends Node2D

@onready var player_health_bar: ProgressBar = %PlayerHealth
@onready var dan_health_bar: ProgressBar = %DanHealth
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var timer_accuracy: TimerAccuracy = %TimerAccuracy

signal low_dan_health
signal no_player_health

var dan_health_val := 100
var player_health_val := 100

var dan_health: int:
	get:
		return dan_health_val
	set(value):
		dan_health_val = value
		dan_health_bar.value = dan_health_val
		if (dan_health_val == 20):
			low_dan_health.emit()

var player_health: int:
	get:
		return player_health_val
	set(value):
		player_health_val = value
		player_health_bar.value = player_health_val
		if (player_health_val <= 0):
			no_player_health.emit()

func _ready() -> void:
	animation_player.play("idle")
	timer_accuracy.correct.connect(
		func() -> void:
			animation_player.stop()
			animation_player.play("player_attack")
			await animation_player.animation_finished
			dan_health -= 10
	)
	timer_accuracy.wrong.connect(
		func() -> void:
			animation_player.stop()
			animation_player.play("player_damage")
			await animation_player.animation_finished
			player_health -= 10
	)
	timer_accuracy.game_done.connect(
		func() -> void:
			timer_accuracy.hide()
			animation_player.play("idle")
			if (dan_health != 20):
				run_game()
	)
	no_player_health.connect(
		func() -> void:
			SceneManager.fail_game(
				func() -> void:
					SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_2/minigame_2.tscn")
			)
	)
	low_dan_health.connect(
		func() -> void:
			$Nodes.process_mode = Node.PROCESS_MODE_DISABLED
			%TimerAccuracy.process_mode = Node.PROCESS_MODE_DISABLED
			$UI/SpaceSpam.process_mode = Node.PROCESS_MODE_INHERIT
			$UI/SpaceSpam.show()
	)
	run_game()

func _process(delta: float) -> void:
	pass

func run_game() -> void:
	await get_tree().create_timer(2).timeout
	animation_player.play("dan_attack_start")
	await animation_player.animation_finished
	timer_accuracy.show()
	timer_accuracy.setup()
