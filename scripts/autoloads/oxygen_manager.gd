extends Node

const DECREASE_RATE: int = 1
const DEFAULT_LEVEL: int = 60
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
	_update_oxygen_status(_current_level)

func _update_oxygen_status(current_level: int = _current_level) -> void:
	if (current_level <= 0):
		oxygen_depleted.emit()
	elif (current_level <= 15):
		oxygen_status_changed.emit(OXYGEN_STATUS.LOW)
	elif (current_level <= 30):
		oxygen_status_changed.emit(OXYGEN_STATUS.WARN)
	else:
		oxygen_status_changed.emit(OXYGEN_STATUS.NORMAL)

func get_oxygen_level() -> int:
	return _current_level

func start_timer() -> void:
	if not _timer_running:
		_timer_running = true
		timer.start()

func pause_timer() -> void:
	_timer_running = false
	timer.stop()

func reset_timer() -> void:
	_current_level = DEFAULT_LEVEL

func remove_oxygen(count: int) -> void:
	print("removed oxy")
	_current_level = _current_level - count
	_update_oxygen_status(_current_level)

func add_oxygen(count: float) -> void:
	_current_level = clamp(_current_level + count, 0, DEFAULT_LEVEL)
	_update_oxygen_status(_current_level)
