extends Control

signal instruction_box_dismissed

var allow_unpause: bool = false
@export var title: String = "Level Objectives"
@export var objectives: String = "Content in here"

func _ready() -> void:
	SceneManager.on_game_paused.connect(
		func() -> void:
			if (DataManager.show_instruction_box):
				show()
	)
	%Title.text = title
	%Objectives.text = objectives

func _on_button_pressed() -> void:
	%AnimationPlayer.play("fade_out")

#func _process(_delta: float) -> void:
	#if (Input.is_action_just_pressed("ui_accept") && allow_unpause):
		#allow_unpause = false
		#%AnimationPlayer.play("fade_out")

func _unpause_game() -> void:
	get_tree().paused = false
	instruction_box_dismissed.emit()
	DataManager.show_instruction_box = false
	hide()
	%AnimationPlayer.play("RESET")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	allow_unpause = true
