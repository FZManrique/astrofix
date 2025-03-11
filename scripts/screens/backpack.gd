extends Control

func _ready() -> void:
	InventoryManager.connect(
		"item_added", _on_item_added
	)
	
	var inventory = InventoryManager.get_inventory_contents()
	inventory.get(0)
	
func _on_item_added(item, _count) -> void:
	if (item == "key"):
		$TextureRect.texture = load("res://art/objects/key.png")
	elif (item == "fuel"):
		$TextureRect.texture = load("res://art/objects/fuel_tank.png")
	else:
		$TextureRect.texture = null
		
