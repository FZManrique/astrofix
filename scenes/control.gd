extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var label: Label = $Panel/Label

var allow_other_scripts = true

@onready var globals = %Globals

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
	globals.disallow_inputs = true

func show_text(msg: String) -> void:
	panel.visible = true
	label.text = msg

func _on_astronaut_on_npc_touch() -> void:
	display_msg("Hello, stranger! Take this key, you'll need it. Good luck!")
		
func _on_fuel_tank_no_key() -> void:
	display_msg("Player: This fuel tank seems to be locked. Looks like I'll need a key.")

func _on_fuel_tank_fuel_collected() -> void:
	display_msg("Level 1 Complete. Press \"DISMISS\" to quit.")
	globals.game_done = true

func _on_button_pressed() -> void:
	if (globals.game_done):
		print("Exiting...")
		get_tree().quit() 
	else:
		allow_other_scripts = true
		globals.disallow_inputs = false
		panel.visible = false
