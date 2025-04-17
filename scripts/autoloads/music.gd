extends AudioStreamPlayer

var current_path: String = ""
var loop: bool = true

func change_db(db: float) -> void:
	volume_db = db

func play_music(path: String, from_position: float = 0.0, loop_music: bool = true) -> void:
	if current_path == path and playing:
		return  # Prevent restart if same music already playing
	
	var stream := ResourceLoader.load(path)
	if not stream or not stream is AudioStream:
		push_error("Invalid music stream: %s" % path)
		return

	self.stream = stream
	self.play(from_position)
	current_path = path
	loop = loop_music

func stop_music() -> void:
	stop()
	current_path = ""
	loop = false

func _on_finished() -> void:
	if loop:
		play()
