extends AudioStreamPlayer

func change_db(db: float) -> void:
	self.volume_db = db

func play_music(path: String, from_position: float = 0.0) -> void:
	self.stream = ResourceLoader.load(path) as AudioStream
	self.play(from_position)
	
func stop_music() -> void:
	self.stop()

func _on_finished() -> void:
	self.play()
