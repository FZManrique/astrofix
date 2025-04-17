extends Node2D

@onready var enemy: CharacterBody2D = %Enemy
@onready var player: CharacterBody2D = %Player
@onready var timer_label: Label = $CanvasLayer/GUI/HBoxContainer/TimerContainer/Timer

@onready var bombs: Node2D = $NavigationRegion2D/Bombs
@onready var timers: Node2D = $NavigationRegion2D/Timers
@onready var fake_exits: Node2D = $NavigationRegion2D/FakeExits

const TIMER_INCREASE := 10
var time_limit := 180

func _ready() -> void:
	GameStateManager.pause_oxygen = true
	GameStateManager.in_minigame = true
	DatabaseManager.unlock_item_by_name("Daniella Mondragon")
	
	DataManager.Level5.in_minigame = true
	Music.play_music("uid://bbv74260pto35")
	start_timer()
	
	for fake_exit in fake_exits.get_children() as Array[Area2D]:
		fake_exit.body_entered.connect(
			func(body: Node2D) -> void:
				if (body == player):
					DialogueManager.show_dialogue_balloon(
						preload("res://dialogue/level_5.dialogue"),
						"fake_exit"
					)
					await DialogueManager.dialogue_ended
					game_over()
		)
	
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
	
	%PlayGame.pressed.connect(
		func() -> void:
			GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "level_5_minigame_1")
			PauseManager.remove_whitelist(%Instructions)
			%Instructions.queue_free()
	)
	
	GameStateManager.add_pause_reason(GameStateManager.PauseType.SYSTEM, "level_5_minigame_1")
	PauseManager.add_whitelist(%Instructions)
	
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
	GameStateManager.fail_game(
		func() -> void:
			SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_1/minigame_1.tscn")
	)

func _on_hit_player() -> void:
	game_over()

func _on_enter_true_exit(body: Node2D) -> void:
	DialogueManager.show_dialogue_balloon(
		preload("res://dialogue/level_5.dialogue"),
		"true_exit"
	)
	await DialogueManager.dialogue_ended
	DataManager.Level5.minigame_1_complete = true
	SceneManager.goto_scene("res://scenes/levels/level_5_minigames/minigame_2/minigame_2.tscn")
