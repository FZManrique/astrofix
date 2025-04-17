extends PanelContainer

func _ready() -> void:
	DatabaseManager.item_unlocked.connect(
		func(item_name: String) -> void:
			($VBoxContainer/Description as Label).text = item_name
			($AnimationPlayer as AnimationPlayer).play(&"show_item")
	)
