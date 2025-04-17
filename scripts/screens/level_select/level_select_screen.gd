extends Control

@export var all_levels: Array[LevelResource]

@onready var top_navigation_content: HBoxContainer = $VBoxContainer/TopNavigation/TopNavigationContent
@onready var detail_content: Control = $VBoxContainer/DetailContent
@onready var title: Label = $VBoxContainer/TopNavigation/TopNavigationContent/VBoxContainer/Title
@onready var description: Label = $VBoxContainer/TopNavigation/TopNavigationContent/VBoxContainer/Description
@onready var main_menu: Button = $VBoxContainer/TopNavigation/TopNavigationContent/MainMenu

@onready var tab_data: Dictionary[String, Dictionary] = {
	"Database": {
		"scene": preload("res://database/database.tscn"),
		"title": "Database",
		"desc": "View info about characters and planets"
	},
	"SelectLevel": {
		"scene": preload("res://scenes/screens/level_select/level_select_content.tscn"),
		"title": "Choose a level",
		"desc": "X of 5 levels complete"
	}
}

var current_tab := ""
var completed_levels := 0

func _exit_tree() -> void:
	GameStateManager.in_level_select = false

func _ready() -> void:
	Music.play_music("res://audio/music/main_menu.wav")
	GameStateManager.in_level_select = true
	main_menu.pressed.connect(
		func() -> void: SceneManager.goto_scene("res://scenes/main.tscn")
	)
	
	for tab_name in tab_data.keys():
		var button := top_navigation_content.get_node(tab_name)
		button.pressed.connect(_on_tab_pressed.bind(button.name))
	
	for resource in all_levels:
		var saved := SaveManager.load_level(resource.level_id, resource)
		if (saved.finished_level):
			completed_levels += 1
	
	_on_tab_pressed("SelectLevel")
		
func _on_tab_pressed(tab_name: String) -> void:
	if tab_name == current_tab:
		return
	_select_tab(tab_name)

func _select_tab(tab_name: String) -> void:
	current_tab = tab_name
	
	var data = tab_data.get(current_tab)
	title.text = data.title
	description.text = data.desc
	if (tab_name == "SelectLevel"):
		description.text = "%d of 5 levels complete" % (completed_levels)

	for n in tab_data.keys() as Array[String]:
		var button: Button = top_navigation_content.get_node(n)
		button.button_pressed = n == tab_name
	
	for i in detail_content.get_children():
		i.queue_free()

	var new_scene := (data.scene as PackedScene).instantiate()
	detail_content.add_child(new_scene)
	
