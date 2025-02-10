extends AudioStreamPlayer

func play_music(path: String) -> void:
	self.stream = ResourceLoader.load(path) as AudioStream
	self.play()
	
func stop_music() -> void:
	self.stop()

func _on_finished() -> void:
	self.play()
