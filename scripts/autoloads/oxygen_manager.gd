extends Node

const DECREASE_RATE: float = 1.0
const DEFAULT_LEVEL: float = 60.0
enum OXYGEN_STATUS {NORMAL, WARN, LOW}

var _current_level: int = DEFAULT_LEVEL
var _timer_running: bool = false

signal oxygen_status_changed(status: OXYGEN_STATUS)
signal oxygen_depleted()

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	# Set up the timer
	timer.wait_time = 1.0  # Decrease every second
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	_current_level -= DECREASE_RATE
	if (_current_level == 0):
		oxygen_depleted.emit()
	elif (_current_level <= 15):
		oxygen_status_changed.emit(OXYGEN_STATUS.LOW)
	elif (_current_level <= 30):
		oxygen_status_changed.emit(OXYGEN_STATUS.WARN)
	else:
		oxygen_status_changed.emit(OXYGEN_STATUS.NORMAL)

func get_oxygen_level():
	return _current_level

func start_timer():
	if not _timer_running:
		_timer_running = true
		timer.start()

func pause_timer():
	_timer_running = false
	timer.stop()

func reset_timer():
	_current_level = DEFAULT_LEVEL

func add_oxygen(count: float):
	_current_level = clamp(_current_level + count, 0, DEFAULT_LEVEL)
