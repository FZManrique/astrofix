extends Node

var oxygen = Globals.OxygenDefaults.default
var oxygen_decrease_rate = Globals.OxygenDefaults.decrease_rate
var fail_triggered = false

signal oxygen_depleted

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func on_start_deplete():
	timer.start()

func _process(delta: float) -> void:
	if (Globals.is_dialogue_shown):
		timer.paused = true
	else:
		timer.paused = false
	
	if (oxygen <= 15):
		label.add_theme_color_override("font_color", Color.RED)
	elif (oxygen <= 30):
		label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		label.add_theme_color_override("font_color", Color(0.48, 0.64, 1.00))

func replenish_oxygen(amount):
	oxygen += amount
	update_oxygen_display()

func update_oxygen_display():
	label.text = "O2: %ds" % oxygen

func _on_timer_timeout():
	if oxygen > 0:
		oxygen -= 1
		update_oxygen_display()
	elif not fail_triggered:
		fail_triggered = true
		oxygen_depleted.emit()
		_trigger_fail_box()

func _trigger_fail_box():
	var dialog = load("res://dialogue/level1.dialogue")
	$AudioStreamPlayer.play()

	DialogueManager.show_dialogue_balloon(dialog, "failed")
	DialogueManager.dialogue_ended.connect(
		_restart
	)

func _restart(_pass):
	get_tree().reload_current_scene() 
	
