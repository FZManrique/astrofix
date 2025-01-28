extends Label

func _ready() -> void:
	OxygenManager.start_timer()
	OxygenManager.connect("oxygen_status_changed", _on_oxygen_status_changed)

func _process(delta: float) -> void:
	var oxygen = OxygenManager.get_oxygen_level()
	self.text = "O2: %ds" % oxygen

func _on_oxygen_status_changed(status: OxygenManager.OXYGEN_STATUS) -> void:
	match status:
		OxygenManager.OXYGEN_STATUS.LOW:
			self.add_theme_color_override("font_color", Color.RED)
		OxygenManager.OXYGEN_STATUS.WARN:
			self.add_theme_color_override("font_color", Color.YELLOW)
		_:
			self.add_theme_color_override("font_color", Color(0.48, 0.64, 1.00))
