extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var label: Label = $Panel/Label

signal on_dismiss

var allow_other_scripts: bool = true

# TODO: DO SIGNIFICANT REFACTOR
func _ready() -> void:
	panel.visible = false
	
func _process(delta: float) -> void:
	if (panel.visible):
		if (Input.is_action_pressed("ui_accept")):
			_on_button_pressed()
	
func display_msg(
	msg: String
) -> void:
	if (allow_other_scripts):
		disallow_inputs()
		show_text(msg)
	
func disallow_inputs() -> void:
	allow_other_scripts = false
	Globals.disallow_inputs = true

func show_text(msg: String) -> void:
	panel.visible = true
	label.text = msg

func _on_button_pressed() -> void:
	if (Globals.game_done):
		print("Exiting...")
		get_tree().quit() 
	else:
		on_dismiss.emit()
		allow_other_scripts = true
		Globals.disallow_inputs = false
		panel.visible = false
