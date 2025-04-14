extends Resource
class_name CutsceneResource
## Represents a cutscene resource.

@export_group("Basic Properties")
## Ordered list of cutscene images
@export var images: Array[Texture2D]
## Ordered list of text for each image
@export_multiline var dialogue: Array[String]
## Choices (if any) - key: dialogue index, value: array of options (strings)
@export var options: Dictionary[int, Array]
@export_group("Music and SFX")
## Background music for the whole cutscene
@export var music: AudioStream
## Ordered list of SFX files (can be empty)
@export var sfx: Array[AudioStream]
@export_group("Modifiers")
## Next scene path
@export var next_scene: PackedScene
## Optional path to script for mutations
@export var mutation_script: Script
## Modifiers for the default wait time
## Key: dialogue index, Value: float (time override)
@export var time_modifiers: Dictionary[int, float]
