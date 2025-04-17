extends CanvasLayer

signal transition_started
signal transition_finished

var fade_to_black := false

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.visible = false
	animation_player.animation_finished.connect(
		func(anim_name: String) -> void:
			if anim_name == "fade_to_black":
				transition_finished.emit()
				if fade_to_black:
					return
				
				animation_player.play("fade_to_normal")
			elif anim_name == "fade_to_normal":
				color_rect.visible = false
	)

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fade_to_black")
	transition_started.emit()
