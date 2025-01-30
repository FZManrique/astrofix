extends Label

func _ready() -> void:
	text = InventoryManager.simple_display_inventory()
	InventoryManager.connect(
		"item_added", _on_item_added
	)

func _on_item_added(_ig, _ig2) -> void:
	text = InventoryManager.simple_display_inventory()
