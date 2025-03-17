extends Control

const BUTTON_COLORS := ["red", "yellow", "green", "blue"]
const SWATCH_COUNT := 4
const FLASH_DURATION := 3

# Variables
var color_sequence := []
var player_sequence := []
var score := 0
var is_game_active := false

var is_validating := false

var colors: Dictionary[String, Texture2D] = {
	"red": load("res://art/level_2/minigame/red.png"),
	"blue": load("res://art/level_2/minigame/blue.png"),
	"green": load("res://art/level_2/minigame/green.png"), 
	"yellow": load("res://art/level_2/minigame/yellow.png")
}

@onready var screen: Dictionary[int, TextureRect] = {
	1: %"1",
	2: %"2",
	3: %"3",
	4: %"4"
}

@onready var buttons: Dictionary[String, Button] = {
	"red": %Red,
	"blue": %Blue,
	"green": %Green,
	"yellow": %Yellow
}

func _ready() -> void:
	DataManager.Level2.is_minigame = true
	%Continue.disabled = true
	is_game_active = true
	generate_color_sequence()
	display_and_hide_color_sequence()
	
	for color in BUTTON_COLORS:
		buttons[color].pressed.connect(
			func() -> void:
				%Click.play()
				if not is_game_active:
					return
				
				player_sequence.append(color)
				display_player_sequence()
				
				if (player_sequence.size() == 4):
					validate_sequence()
		)
	
	for color in BUTTON_COLORS:
		buttons[color].disabled = true
	

func display_and_hide_color_sequence() -> void:
	for node: int in screen.keys():
		screen[node].show()
	
	for i in range(color_sequence.size()):
		var color_name: String = color_sequence[i]
		var texture: Resource = colors[color_name]
		var node: TextureRect = screen[i + 1]
		node.texture = texture
		
	await get_tree().create_timer(FLASH_DURATION).timeout
	
	for node: int in screen.keys():
		screen[node].hide()
	
	for color: String in BUTTON_COLORS:
		buttons[color].disabled = false

func display_player_sequence() -> void:
	for i in range(player_sequence.size()):
		var color_name: String = player_sequence[i]
		var texture: Resource = colors[color_name]
		var node: TextureRect = screen[i + 1]
		node.texture = texture
		node.show()

func generate_color_sequence() -> void:
	color_sequence.clear()
	for i in range(SWATCH_COUNT):
		color_sequence.append(BUTTON_COLORS[randi() % BUTTON_COLORS.size()])

func validate_sequence() -> void:
	if (is_validating):
		return
	
	is_validating = true
	var is_correct := true
	
	for i in range(SWATCH_COUNT):
		if player_sequence[i] != color_sequence[i]:
			is_correct = false
	
	for color: String in BUTTON_COLORS:
		buttons[color].disabled = true
	
	for node: int in screen.keys():
		screen[node].hide()
	
	if (is_correct):
		%Correct.play()
		%Progress.text = "Correct! Applying fixes..."
		score += 1
		
		if (score == 4):
			%Progress.text = "Repair complete."
			%Continue.disabled = false
			var hide = [$VBoxContainer/Description, $VBoxContainer/HBoxContainer, $VBoxContainer/CenterContainer]
			DataManager.Level2.has_fixed_spacesuit = true
			for i in hide:
				i.hide()
			return
	else:
		%Fail.play()
		%Progress.text = "Invalid combination. Please try again."
	
	player_sequence.clear()
	await get_tree().create_timer(FLASH_DURATION).timeout

	%Progress.text = "Repair percentage: %s of 4" % score
	generate_color_sequence()
	display_and_hide_color_sequence()
	
	is_validating = false

func _on_continue_pressed() -> void:
	DataManager.Level2.is_minigame = false
	SceneManager.goto_scene("res://scenes/levels/level_2.tscn")
