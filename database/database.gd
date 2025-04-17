extends Control

signal database_shown
signal database_hidden

@onready var characters_list: VBoxContainer = %CharactersList
@onready var planets_list: VBoxContainer = %PlanetsList
@onready var objects_list: VBoxContainer = %ObjectsList
@onready var souvenirs_list: VBoxContainer = %SouvenirsList
@onready var image: TextureRect = %Image
@onready var label: Label = %Label
@onready var description: Label = %Description
@onready var debug_unlock_panel: VBoxContainer = %DebugUnlock

var manager := DatabaseManager
var selected_item: DatabaseItem

#region Default functions
func _input(event):
	if event.is_action_pressed(&"ui_cancel"):
		_clear_display()

func _ready() -> void:
	await get_tree().process_frame
	database_shown.emit()

	_generate_ui()
	_clear_display()
	
	DatabaseManager.navigate_to.connect(
		func(item: DatabaseItem) -> void:
			var is_unlocked = manager.unlocked_items.get(item.resource_path, false)
			_show_item(item, is_unlocked)
	)
#endregion

func _generate_ui() -> void:
	# Debug toggle
	var title := Label.new()
	title.text = "DEBUG"
	debug_unlock_panel.add_child(title)
	
	var sorted_items := manager.items.duplicate() as Array[DatabaseItem]
	sorted_items.sort_custom(func(a: DatabaseItem, b: DatabaseItem) -> bool: return a.order < b.order)
	for item in sorted_items:
		var button := Button.new()
		var res_path := item.resource_path
		var is_unlocked := manager.unlocked_items[res_path]

		button.text = item.name if is_unlocked else "???"
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.flat = true
		button.disabled = false
		if !is_unlocked:
			button.tooltip_text = "This entry is locked"
		
		button.connect("pressed", func(): _show_item(item, is_unlocked))

		match item.category:
			DatabaseItem.CATEGORIES.CHARACTERS:
				characters_list.add_child(button)
			DatabaseItem.CATEGORIES.PLANETS:
				planets_list.add_child(button)
			DatabaseItem.CATEGORIES.OBJECTS:
				objects_list.add_child(button)
			DatabaseItem.CATEGORIES.SOUVENIRS:
				souvenirs_list.add_child(button)
		
		var toggle := CheckBox.new()
		toggle.text = item.name
		toggle.button_pressed = is_unlocked
		toggle.connect("toggled", func(pressed): 
			manager.set_unlocked(res_path, pressed)
			_reload_ui()
		)
		debug_unlock_panel.add_child(toggle)

func _reload_ui() -> void:
	var lists = [characters_list, planets_list, objects_list, souvenirs_list, debug_unlock_panel]
	for item in lists:
		delete_all_children(item)

	_generate_ui()
	
	if selected_item and !manager.unlocked_items.get(selected_item.resource_path, false):
		_clear_display()

func _clear_display() -> void:
	image.texture = null
	label.text = "Select an item to show info"
	description.text = ""
	selected_item = null

func _show_item(item: DatabaseItem, is_unlocked: bool = false) -> void:
	selected_item = item
	if is_unlocked:
		image.texture = item.image
		label.text = item.name
		description.text = item.description
	else:
		image.texture = preload("res://database/images/glitched_image.png")
		label.text = "Unknown entry"
		description.text = "Complete levels to unlock this entry"
	
	_apply_image_style(item.category)

func _apply_image_style(category: DatabaseItem.CATEGORIES):
	match category:
		DatabaseItem.CATEGORIES.OBJECTS:
			pass
		DatabaseItem.CATEGORIES.PLANETS:
			pass
		DatabaseItem.CATEGORIES.CHARACTERS:
			pass
		_:
			pass


#region Helper functions

func delete_all_children(node: Control) -> void:
	for child in node.get_children():
		child.queue_free()
#endregion
