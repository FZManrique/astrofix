extends Control

@onready var panel: Panel = $Background
@onready var button: Button = $"Background/Dialog Button"
@onready var label: Label = $"Background/Dialog Label"

signal on_button_clicked

func _ready() -> void:
	panel.visible = false
	
func _process(delta: float) -> void:
	if (panel.visible):
		if (Input.is_action_pressed("ui_accept")):
			_on_button_pressed()

func show_dialog_box(
	msg: String,
	action: String = "OK",
) -> void:
	Globals.disallow_inputs = true
	_show_text(msg)
	button.text = action

func _show_text(msg: String) -> void:
	panel.visible = true
	label.text = msg

func _on_button_pressed() -> void:
	if (Globals.game_done):
		print("Exiting...")
		get_tree().quit() 
	else:
		on_button_clicked.emit()
		Globals.disallow_inputs = false
		panel.visible = false
