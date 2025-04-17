extends CanvasLayer

signal pause_toggled(paused: bool)

var is_paused := false
var whitelist: Array[Node] = []

func _ready() -> void:
	set_process_input(true)
	GameStateManager.game_state_changed.connect(_update_pause_state)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause") and GameStateManager.can_player_toggle_pause():
		if GameStateManager.player_reasons.has("pause_menu"):
			GameStateManager.remove_pause_reason(GameStateManager.PauseType.PLAYER, "pause_menu")
			_update_pause_state()
			$PauseMenu.hide()
		else:
			GameStateManager.add_pause_reason(GameStateManager.PauseType.PLAYER, "pause_menu")
			_update_pause_state()
			$PauseMenu.show()

func _update_pause_state() -> void:
	var should_pause := GameStateManager.should_game_pause()
	if should_pause != is_paused:
		is_paused = should_pause
		get_tree().paused = is_paused
		pause_toggled.emit(is_paused)

		for node in whitelist:
			if node.is_inside_tree():
				node.process_mode = Node.PROCESS_MODE_ALWAYS if is_paused else Node.PROCESS_MODE_INHERIT

func add_whitelist(node: Node) -> void:
	if node not in whitelist:
		whitelist.append(node)
		node.process_mode = Node.PROCESS_MODE_ALWAYS

func remove_whitelist(node: Node) -> void:
	if node in whitelist:
		whitelist.erase(node)
		node.process_mode = Node.PROCESS_MODE_INHERIT
