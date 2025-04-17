extends Resource
class_name LevelResource

@export_group("General Properties")
@export var level_id: String = ""
@export var description: String = ""
@export var finished_level: bool = false

@export_group("Flags", "flag_")
@export var flag_bool: Dictionary[StringName, bool]
@export var flag_int: Dictionary[StringName, int]
@export var flag_float: Dictionary[StringName, float]
