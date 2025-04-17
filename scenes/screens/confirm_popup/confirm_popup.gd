extends Control

@onready var title: Label = $CenterContainer/PanelContainer/VBoxContainer/Title
@onready var description: Label = $CenterContainer/PanelContainer/VBoxContainer/Description
@onready var accept: Button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/Accept
@onready var cancel: Button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/Cancel

signal accepted
signal canceled

func _ready() -> void:
	accept.grab_focus()
	get_viewport().set_input_as_handled()

func set_content(new_title: String, new_description: String, new_accept: String = "Accept", new_cancel: String = "Cancel") -> void:
	title.text = new_title
	description.text = new_description
	accept.text = new_accept
	cancel.text = new_cancel


func _on_accept_pressed() -> void:
	accepted.emit()
	queue_free()


func _on_cancel_pressed() -> void:
	canceled.emit()
	queue_free()
