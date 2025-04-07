extends Control
class_name CutsceneManager

@export var typing_speed: float = 0.02

@onready var background: TextureRect = $Background
@onready var title: RichTextLabel = $Panel/Dialogue/VBoxContainer/Title
@onready var content: RichTextLabel = $Panel/Dialogue/VBoxContainer/Content
@onready var music: AudioStreamPlayer = $Music
@onready var sfx: AudioStreamPlayer = $SFX
@onready var options_container: HBoxContainer = $Panel/Dialogue/Responses/ResponsesMenu
@onready var skip_button: Button = $Panel/Dialogue/SkipButton

var current_index := 0
var image_wait_time := 2.0
var mutation_script: CutsceneMutations = null

var skip_typing := false
var is_typing := false

var cutscene: CutsceneResource = DataManager.current_cutscene

signal on_start
signal on_step(index: int)
signal on_end

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_skip_typing"):  # Space by default
		skip_typing = true

func _ready() -> void:
	# Stop global music
	Music.stop_music()
	
	if cutscene:
		play_cutscene()
	
	if cutscene.mutation_script:
		mutation_script = cutscene.mutation_script.new()
		mutation_script.cutscene_player = self
		on_start.connect(mutation_script._on_start)
		on_step.connect(mutation_script._on_step)
		on_end.connect(mutation_script._on_end)
	
	DataManager.in_cutscene = true
	
	skip_button.visible = false  # Hide initially
	await get_tree().create_timer(3.0).timeout  # Delay before showing
	skip_button.visible = true
	
	skip_button.pressed.connect(end_cutscene)

func play_cutscene() -> void:
	on_start.emit()

	music.stream = cutscene.music
	music.play()

	show_scene()

func show_scene() -> void:
	if current_index >= cutscene.images.size():
		end_cutscene()
		return

	background.texture = cutscene.images[current_index]

	if cutscene.sfx.size() > current_index and cutscene.sfx[current_index]:
		sfx.stream = cutscene.sfx[current_index]
		sfx.play()

	on_step.emit(current_index)
	
	var text := cutscene.dialogue[current_index]
	if (text):
		(%Title as RichTextLabel).show()
	else:
		(%Title as RichTextLabel).hide()
	
	if ("@ai" in text):
		(%Title as RichTextLabel).text = "AI"
		text = text.replace("@ai", "")
	else:
		(%Title as RichTextLabel).text = "Player"
	
	await type_text(text)
	is_typing = false
	
	if cutscene.options.has(current_index):
		show_options(cutscene.options[current_index])
	else:
		var options_nodes := options_container.get_children()
		if not options_nodes.is_empty():
			for option in options_container.get_children():
				option.queue_free()
		
		var wait_time = \
			cutscene.time_modifiers[current_index] if cutscene.time_modifiers.has(current_index) else image_wait_time
		print(wait_time)
		
		await get_tree().create_timer(wait_time).timeout
		next_scene()

func show_options(options: Array[Variant]) -> void:
	if options.is_empty(): next_scene()
	
	options_container.show()
	for child in options_container.get_children():
		child.queue_free()

	for option_text in (options as Array[String]):
		var button := Button.new()
		button.flat = true
		button.text = option_text
		button.pressed.connect(next_scene)  # No actual effect, just proceeds
		options_container.add_child(button)

func type_text(text: String) -> void:
	content.text = ""
	is_typing = true
	skip_typing = false  # Reset skip flag
	
	for i in range(text.length()):
		if skip_typing:  # Instantly display full text if skipped
			content.text = text
			return
		var char := text[i]
		content.text += char
		# wait for typing
		if (char == "," or char == "." or char == "?" or char == "!"):
			await get_tree().create_timer(0.2).timeout
		
		await get_tree().create_timer(typing_speed).timeout

func next_scene() -> void:
	current_index += 1
	show_scene()

func end_cutscene() -> void:
	on_end.emit()
	DataManager.in_cutscene = false

	if cutscene.next_scene:
		SceneManager.goto_packed_scene(cutscene.next_scene)
	
