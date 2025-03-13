extends Control

const BUTTON_COLORS := ["red", "yellow", "green", "blue"]
const SWATCH_COUNT := 4
const FLASH_DURATION := 2.0
const FLASH_INTERVAL := 0.5

# Variables
var color_sequence := []
var player_sequence := []
var score := 0
var is_game_active := false

@onready var buttons: Dictionary[String, Button] = {
	"red": %Red,
	"blue": %Blue,
	"green": %Green,
	"yellow": %Yellow
}

func _ready() -> void:
	for color in BUTTON_COLORS:
		buttons[color].pressed.connect(
			func(color) -> void:
				if not is_game_active:
					return
				
				player_sequence.append(color)
				# screen.display_color(color)
		)
		
func generate_color_sequence() -> void:
	color_sequence.clear()
	for i in range(SWATCH_COUNT):
		color_sequence.append(BUTTON_COLORS[randi() % BUTTON_COLORS.size()])

func validate_sequence() -> bool:
	for i in range(player_sequence.size()):
		if player_sequence[i] != color_sequence[i]:
			return false
	return true
