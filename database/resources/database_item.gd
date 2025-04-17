class_name DatabaseItem
extends Resource

enum CATEGORIES {
	CHARACTERS,
	PLANETS,
	OBJECTS,
	SOUVENIRS
}

@export var unlocked: bool = false
@export var category: CATEGORIES
@export var order: int
@export var image: Texture2D
@export var name: StringName
@export_multiline var description: String
