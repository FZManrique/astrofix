extends CutsceneMutations

var head_throbbing_sound: AudioStreamPlayer

func play_ongoing_sfx(sound: AudioStream, auto_restart: bool = true) -> AudioStreamPlayer:
	var sound_node := AudioStreamPlayer.new()
	sound_node.stream = sound
	sound_node.bus = "SFX"
	cutscene_player.add_child(sound_node)
	if (auto_restart):
		sound_node.finished.connect(
			func() -> void:
				sound_node.play()
		)
	sound_node.play()
	return sound_node

func _on_start() -> void:
	play_ongoing_sfx(load("res://cutscenes/sfx/common/spaceship_ambience.mp3"))

func _on_step(index: int) -> void:
	match index:
		1:
			head_throbbing_sound = play_ongoing_sfx(load("res://cutscenes/sfx/level_2/head_throbbing.mp3"))
		5:
			var tween := cutscene_player.get_tree().create_tween()
			var cutscene_sfx := cutscene_player.sfx
			
			tween.tween_property(
				cutscene_sfx, "volume_linear", 0, 5
			)
			tween.set_parallel()
			tween.tween_property(
				head_throbbing_sound, "volume_linear", 0, 5
			)

func _on_end() -> void:
	pass
