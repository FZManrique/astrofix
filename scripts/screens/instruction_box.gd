extends Control

signal instruction_box_dismissed

@export var title: String = "Level Objectives"
@export var objectives: String = "Content in here"

@onready var title_label := %Title
@onready var objectives_label := %Objectives
@onready var anim := %AnimationPlayer
@onready var notifier := $VisibleOnScreenNotifier2D

var allow_dismiss := false

func show_instruction_box() -> void:
	if not get_tree().paused:
		allow_dismiss = false
		GameStateManager.add_pause_reason(GameStateManager.PauseType.SYSTEM, "instruction_box")
		PauseManager.add_whitelist(self)

		show()
		await notifier.screen_entered
		allow_dismiss = true
		anim.play("fade_in")
		title_label.text = title
		objectives_label.text = objectives

func _ready() -> void:
	title_label.text = title
	objectives_label.text = objectives

	hide()

func _on_button_pressed() -> void:
	if allow_dismiss:
		anim.play("fade_out")
		await get_tree().create_timer(0.3).timeout
		_unpause_game()

func _unpause_game() -> void:
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.SYSTEM, "instruction_box")
	PauseManager.remove_whitelist(self)
	instruction_box_dismissed.emit()
	hide()
	anim.play("RESET")
