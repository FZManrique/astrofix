extends Control

@onready var slot_icons: Array[TextureRect] = [$Slot1/TextureRect, $Slot2/TextureRect]
@onready var slot_labels: Array[Label] = [$Slot1/Label, $Slot2/Label]

var slots: Array[Variant] = [null, null]


func _ready() -> void:
	InventoryManager.item_added.connect(_on_item_added)
	InventoryManager.item_removed.connect(_on_item_removed)

	for item in InventoryManager.inventory.keys() as Array[String]:
		_add_or_update_slot(item)


func _on_item_removed(item: String, _count: int) -> void:
	if not InventoryManager.inventory.has(item):
		_clear_slot(item)
	else:
		_add_or_update_slot(item)


func _on_item_added(item: String, _count: int) -> void:
	_add_or_update_slot(item)


func _add_or_update_slot(item: String) -> void:
	var index := slots.find(item)
	if index == -1:
		index = slots.find(null)
		if index == -1:
			index = 0
		slots[index] = item

	slot_icons[index].texture = InventoryManager.get_icon(item)

	var qty: int = InventoryManager.inventory.get(item, 0)
	print(qty)
	slot_labels[index].text = str(qty) if qty > 0 else ""


func _clear_slot(item: String) -> void:
	var index: int = slots.find(item)
	if index == -1:
		return
	slots[index] = null
	slot_icons[index].texture = null
	slot_labels[index].text = ""
