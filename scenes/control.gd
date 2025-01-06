extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var label: Label = $Panel/Label

var allow_other_scripts = true
@onready var globals = %Globals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible = false
	
func disallow_inputs() -> void:
	allow_other_scripts = false
	globals.disallow_inputs = true

func _on_astronaut_on_npc_touch() -> void:
	if (allow_other_scripts):
		disallow_inputs()
		panel.visible = true
		label.text = "Blablabla placeholder text.\nBy the way, free key for you!"

func _on_fuel_tank_no_key() -> void:
	if (allow_other_scripts):
		disallow_inputs()
		panel.visible = true
		label.text = "YOU NEED A KEY!!!!"


func _on_fuel_tank_fuel_collected() -> void:
	if (allow_other_scripts):
		disallow_inputs()
		panel.visible = true
		label.text = "YAY! GAME COMPLETE!!!!\nPress Dismiss to quit."
		globals.game_done = true

func _on_button_pressed() -> void:
	if (globals.game_done):
		get_tree().quit() 
	else:
		allow_other_scripts = true
		globals.disallow_inputs = false
		panel.visible = false
