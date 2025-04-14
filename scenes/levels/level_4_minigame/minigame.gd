extends CanvasLayer

signal on_dismiss

@onready var pieces: Control = %Pieces
var current_pieces = 0

func _ready() -> void:
	get_tree().paused = true
	%Exit.hide()
	
	pieces.modulate.a = 0.9
	
	for piece: PuzzlePiece in %Pieces.get_children():
		piece.on_correct_piece_dropped.connect(
			func():
				current_pieces += 1
				InventoryManager.remove_item_from_inventory("crystal", 1)
				
				if (current_pieces == 5):
					%GameComplete.play()
					%Exit.show()
					pieces.modulate.a = 1
					%Pieces.process_mode = Node.PROCESS_MODE_DISABLED
		)

func _on_button_pressed() -> void:
	get_tree().paused = false
	on_dismiss.emit()
	queue_free()
