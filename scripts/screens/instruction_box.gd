extends Control

var allow_unpause: bool = false

signal instruction_box_dismissed

func _ready() -> void:
	SceneManager.on_game_paused.connect(
		func():
			show()
	)

func _on_button_pressed() -> void:
	get_tree().paused = false
	instruction_box_dismissed.emit()
	DataManager.show_instruction_box = false
	queue_free()

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_pause") && allow_unpause):
		allow_unpause = false
		get_tree().paused = false
		instruction_box_dismissed.emit()
		DataManager.show_instruction_box = false
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	allow_unpause = true
