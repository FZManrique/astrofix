extends Control

const SettingsScene := preload("res://scripts/screens/settings_menu.gd")
const Database := preload("res://database/database.gd")

@export var settings_scene: PackedScene
@onready var root_panel: ColorRect = $ColorRect

# Pause menu showing is now handled by `pause_manager.gd`

func _ready() -> void:
	hide()
	PauseManager.pause_toggled.connect(_on_pause_changed)

func _on_resume_pressed() -> void:
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.PLAYER, "pause_menu")
	hide()

func _on_settings_pressed() -> void:
	var instance: SettingsScene = settings_scene.instantiate()
	instance.on_settings_show.connect(func() -> void: root_panel.hide())
	instance.on_settings_hide.connect(func() -> void: root_panel.show())
	add_child(instance)

func _on_main_menu_pressed() -> void:
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.PLAYER, "pause_menu")
	SceneManager.goto_scene("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	GameStateManager.remove_pause_reason(GameStateManager.PauseType.PLAYER, "pause_menu")
	GameStateManager.quit_game()

func _on_pause_changed(paused: bool) -> void:
	if paused and GameStateManager.player_reasons.has("pause_menu"):
		show()
	else:
		hide()
