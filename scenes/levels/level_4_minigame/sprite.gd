class_name PuzzlePiece
extends TextureRect

@export var index: int = 1
@export var is_final_location: bool = false

var is_current_item := false

signal on_correct_piece_dropped

func _notification(what: int) -> void:
	if (what == NOTIFICATION_DRAG_END):
		if self.is_drag_successful() && is_current_item:
			self.visible = false
			is_current_item = false
		elif is_current_item:
			self.modulate.a = 1
			is_current_item = false

func _get_drag_data(at_position: Vector2) -> Variant:
	if (is_final_location): return
	var node = Control.new()
	
	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.rotation_degrees = 90
	texture_rect.position = -0.3 * texture_rect.size
	
	node.add_child(texture_rect)
	set_drag_preview(node)
	
	modulate.a = 0.5
	is_current_item = true
	
	return duplicate()
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is PuzzlePiece && data.index == index && !is_current_item

func _drop_data(at_position: Vector2, data: Variant) -> void:
	texture = (data as PuzzlePiece).texture
	on_correct_piece_dropped.emit()
