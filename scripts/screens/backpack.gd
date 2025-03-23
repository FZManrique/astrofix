extends Control

func _ready() -> void:
	InventoryManager.connect(
		"item_added", _on_item_added
	)
	
	var inventory = InventoryManager.get_inventory_contents()
	
func _on_item_added(item: String, _count: int) -> void:
	if (item == "key"):
		$TextureRect.texture = load("res://art/objects/key.png")
	elif (item == "fuel"):
		$TextureRect.texture = load("res://art/objects/fuel_tank.png")
	elif (item == "cover"):
		$TextureRect.texture = load("res://art/level_3/gas_cover.png")
	else:
		$TextureRect.texture = null
		
