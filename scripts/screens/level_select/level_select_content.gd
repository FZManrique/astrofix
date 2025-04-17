extends VBoxContainer

@export var all_levels: Array[LevelResource]

@onready var planets: GridContainer = $CenterContainer/Planets
@onready var level_name: Label = $BottomNavigation/HBoxContainer/VBoxContainer/LevelName
@onready var description: Label = $BottomNavigation/HBoxContainer/VBoxContainer/Description
@onready var play_level: Button = $BottomNavigation/HBoxContainer/PlayLevel
@onready var view_in_database: Button = $BottomNavigation/HBoxContainer/ViewInDatabase
@onready var bottom_navigation: MarginContainer = $BottomNavigation

var selected_level: LevelResource = null
var level_data: Dictionary = {}  # { level_id: { resource, finished_level } }
var ordered_levels: Array[StringName] = []

func _ready() -> void:
	_load_level_data()
	_setup_planet_buttons()
	bottom_navigation.hide()
	
	selected_level = preload("res://level_data/level_1.tres")
	_update_detail_pane()

func _load_level_data() -> void:
	for resource in all_levels:
		var saved := SaveManager.load_level(resource.level_id, resource)
		level_data[resource.level_id] = {
			"resource": saved,
			"finished_level": saved.finished_level
		}
		ordered_levels.append(resource.level_id)

func _setup_planet_buttons() -> void:
	for i in ordered_levels.size():
		var level_id := ordered_levels[i]
		var planet: AspectRatioContainer = planets.get_node_or_null((level_id as String) as NodePath)
		if not planet: continue

		var unlocked: bool = i == 0 or level_data[ordered_levels[i - 1]]["finished_level"]

		var icon: TextureRect = planet.get_node("TextureRect")
		var click_area: Button = planet.get_node("Button")

		# Style
		icon.modulate = _get_base_color(unlocked)
		click_area.disabled = not unlocked

		click_area.pressed.connect(func():
			if selected_level.level_id == level_id: return

			selected_level = level_data[level_id]["resource"]
			_update_all_planet_colors()
			_update_detail_pane()
		)

		click_area.mouse_entered.connect(func():
			if level_id == selected_level.level_id: return
			icon.modulate = _get_hover_color(unlocked)
		)

		click_area.mouse_exited.connect(func():
			if level_id == selected_level.level_id: return
			icon.modulate = _get_base_color(unlocked)
		)

func _get_base_color(unlocked: bool) -> Color:
	return Color(1, 1, 1, 1) if unlocked else Color(0.8, 0.8, 0.8, 0.3)

func _get_hover_color(unlocked: bool) -> Color:
	return Color(1.1, 1.1, 1.1, 1) if unlocked else _get_base_color(false)

func _get_selected_color() -> Color:
	return Color(0.6, 0.8, 1.0, 1)

func _update_all_planet_colors() -> void:
	for i in ordered_levels.size():
		var level_id := ordered_levels[i]
		var planet: AspectRatioContainer = planets.get_node_or_null((level_id as String) as NodePath)
		if not planet: continue

		var icon: TextureRect = planet.get_node("TextureRect")
		var unlocked: bool = i == 0 or level_data[ordered_levels[i - 1]]["finished_level"]

		icon.modulate = (
			_get_selected_color() if selected_level.level_id == level_id
			else _get_base_color(unlocked)
		)

func _update_detail_pane() -> void:
	if not selected_level: return

	bottom_navigation.show()
	level_name.text = selected_level.level_id
	description.text = selected_level.description

	var handle_play_level = func() -> void: _handle_play_level()
	var handle_view_in_database = func() -> void: DatabaseManager.navigate_to_entry(selected_level.level_id)

	if not play_level.pressed.is_connected(handle_play_level):
		play_level.pressed.connect(handle_play_level)

	if not view_in_database.pressed.is_connected(handle_view_in_database):
		view_in_database.pressed.connect(handle_view_in_database)

	play_level.disabled = false

var is_added := false
var accepted := false

func _handle_play_level() -> void:
	var id := selected_level.level_id
	var idx := ordered_levels.find(id)
	if idx == -1: return
	
	if selected_level.finished_level:
		if (is_added): return
		is_added = true
		const ConfirmPopup = preload("res://scenes/screens/confirm_popup/confirm_popup.gd")
		var confirm_popup_scene = preload("res://scenes/screens/confirm_popup/confirm_popup.tscn")
		
		var confirm_popup := confirm_popup_scene.instantiate()
		get_node("/root").add_child(confirm_popup)
						
		confirm_popup.set_content(
			"Level already completed",
			"Replay level? All progress will be reset.",
			"Replay level"
		)
		
		confirm_popup.accepted.connect(func() -> void: print("yes"); accepted = true)
		confirm_popup.canceled.connect(func() -> void: print("no"); accepted = false)
		
		await confirm_popup.tree_exited  # wait until popup is gone
		
		print("accepted", accepted)

		is_added = false
		if not accepted:
			return

		reset_selected_level()

	GameStateManager.current_cutscene = load("res://cutscenes/data/level_%d.tres" % (idx + 1))
	GameStateManager.start_level(id, selected_level)
	SceneManager.goto_scene("res://cutscenes/cutscene_manager.tscn")

func reset_selected_level() -> void:
	if not selected_level: return
	var id := selected_level.level_id

	# Delete saved file (if it exists)
	SaveManager.clear_level(id)
	
	# Reload default resource from GameStateManager
	var default: LevelResource = GameStateManager.levels.get(id)
	if default == null: return

	level_data[id] = {
		"resource": default,
		"finished_level": false
	}
	selected_level = default
	_update_detail_pane()
	_update_all_planet_colors()
