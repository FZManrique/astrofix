extends AudioStreamPlayer

func play_music(path: String, from_position: float = 0.0) -> void:
	self.stream = ResourceLoader.load(path) as AudioStream
	self.play(from_position)
	
func stop_music() -> void:
	self.stop()

func _on_finished() -> void:
	self.play()
