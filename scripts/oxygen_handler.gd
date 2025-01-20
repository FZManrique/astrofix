extends Node

var oxygen = 60  # Default oxygen in seconds
var oxygen_decrease_rate = 1.0  # 1 second per decrement
var fail_triggered = false

# Signal to communicate failure (optional)
signal oxygen_depleted

@onready var label: Label = $Label

func on_start_deplete():
	# Start oxygen countdown
	$Timer.start()

func _process(delta: float) -> void:
	if (oxygen <= 15):
		label.add_theme_color_override("font_color", Color.RED)
	elif (oxygen <= 30):
		label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		label.add_theme_color_override("font_color", Color(0.48, 0.64, 1.00))

func _on_timer_timeout():
	if oxygen > 0:
		oxygen -= 1
		update_oxygen_display()
	elif not fail_triggered:
		fail_triggered = true
		emit_signal("oxygen_depleted")
		trigger_fail_box()

func replenish_oxygen(amount):
	oxygen += amount
	update_oxygen_display()

func update_oxygen_display():
	label.text = "O2: %ds" % oxygen

func trigger_fail_box():
	print("Oxygen depleted. Failure triggered!")
	var dialog = load("res://dialogue/level1.dialogue")
	$AudioStreamPlayer.play()
	# this is bad practice
	$"../../../Music".stop()
	DialogueManager.show_dialogue_balloon(dialog, "failed")
	DialogueManager.dialogue_ended.connect(
		_restart
	)

func _restart(_pass):
	get_tree().reload_current_scene() 
	
