extends Area2D

@export var image: Texture2D
@export var database_item: DatabaseItem

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = image
	
	body_entered.connect(
		func(body: Node2D) -> void:
			DatabaseManager.unlock_item_by_path(database_item.resource_path)
			queue_free()
	)
