extends ProgressBar

func _ready() -> void:
	OxygenManager.start_timer()
	OxygenManager.connect("oxygen_status_changed", _on_oxygen_status_changed)

func _process(_delta: float) -> void:
	var oxygen := OxygenManager.get_oxygen_level()
	self.value = oxygen

func _on_oxygen_status_changed(status: OxygenManager.OXYGEN_STATUS) -> void:
	var stylebox := load("res://scenes/themes/progress_bar/progress_blue.tres") as StyleBoxFlat
	
	match status:
		OxygenManager.OXYGEN_STATUS.LOW:
			stylebox = load("res://scenes/themes/progress_bar/progress_red.tres") as StyleBoxFlat
		OxygenManager.OXYGEN_STATUS.WARN:
			stylebox = load("res://scenes/themes/progress_bar/progress_yellow.tres") as StyleBoxFlat
		_:
			stylebox = load("res://scenes/themes/progress_bar/progress_blue.tres") as StyleBoxFlat
	
	self.add_theme_stylebox_override("fill", stylebox)
