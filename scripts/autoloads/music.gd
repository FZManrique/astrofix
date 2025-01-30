extends AudioStreamPlayer

func play_music(path: String):
	var stream = ResourceLoader.load(path) as AudioStream

	self.stream = stream
	self.play()
	
func stop_music() -> void:
	self.stop()

func _on_finished() -> void:
	self.play()
