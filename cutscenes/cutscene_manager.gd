extends Control
class_name CutsceneManager

@export var image_wait_time: float = 2.0
@export var typing_speed: float = 0.02

@onready var background: TextureRect = $Background
@onready var title: RichTextLabel = $Panel/Dialogue/VBoxContainer/Title
@onready var content: RichTextLabel = $Panel/Dialogue/VBoxContainer/Content
@onready var music: AudioStreamPlayer = $Music
@onready var sfx: AudioStreamPlayer = $SFX
@onready var options_container: HBoxContainer = $Panel/Dialogue/Responses/ResponsesMenu
@onready var skip_button: Button = $Panel/Dialogue/SkipButton

var current_index := 0
var mutation_script: CutsceneMutations = null
var skip_typing = false

var cutscene: CutsceneResource = DataManager.current_cutscene

signal on_start
signal on_step(index: int)
signal on_end

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # ESC by default
		skip_typing = true

func _ready() -> void:
	# Stop global music
	Music.stop_music()
	
	if cutscene:
		play_cutscene()
	
	if cutscene.mutation_script:
		mutation_script = cutscene.mutation_script.new()
		on_start.connect(mutation_script._on_start)
		on_step.connect(mutation_script._on_step)
		on_end.connect(mutation_script._on_end)
	
	DataManager.in_cutscene = true
	
	skip_button.visible = false  # Hide initially
	await get_tree().create_timer(3.0).timeout  # Delay before showing
	skip_button.visible = true
	
	skip_button.pressed.connect(end_cutscene)

func play_cutscene():
	on_start.emit()

	music.stream = cutscene.music
	music.play()

	show_scene()

func show_scene():
	if current_index >= cutscene.images.size():
		end_cutscene()
		return

	background.texture = cutscene.images[current_index]

	if cutscene.sfx.size() > current_index and cutscene.sfx[current_index]:
		sfx.stream = cutscene.sfx[current_index]
		sfx.play()

	on_step.emit(current_index)
	
	await type_text(cutscene.dialogue[current_index])
	if cutscene.options.has(current_index):
		show_options(cutscene.options[current_index])
		return

	await get_tree().create_timer(image_wait_time).timeout
	next_scene()

func show_options(options):
	options_container.show()
	for child in options_container.get_children():
		child.queue_free()

	for option_text in options:
		var button = Button.new()
		button.flat = true
		button.text = option_text
		button.pressed.connect(next_scene)  # No actual effect, just proceeds
		options_container.add_child(button)

func type_text(text: String):
	content.text = ""
	skip_typing = false  # Reset skip flag
	
	for i in range(text.length()):
		if skip_typing:  # Instantly display full text if skipped
			content.text = text
			return
		content.text += text[i]
		await get_tree().create_timer(typing_speed).timeout

func next_scene():
	current_index += 1
	show_scene()

func end_cutscene():
	on_end.emit()
	DataManager.in_cutscene = false

	if cutscene.next_scene:
		SceneManager.goto_packed_scene(cutscene.next_scene)
	
