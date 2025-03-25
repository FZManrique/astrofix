extends TextureRect

func _get_drag_data(at_position: Vector2) -> Variant:
	var node = Control.new()
	
	var texture_rect = TextureRect.new()
	texture_rect.texture = texture
	texture_rect.rotation_degrees = 90
	texture_rect.position = -0.5 * texture_rect.size
	
	node.add_child(texture_rect)
	set_drag_preview(node)
	
	return texture
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D

func _drop_data(at_position: Vector2, data: Variant) -> void:
	texture = data
	
