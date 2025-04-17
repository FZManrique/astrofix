# Globals class
# Handles scene changing 

extends Node

var current_scene: Node = null

func _ready() -> void:
	var root := get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)

#region Scene Transitions
func goto_scene(path: String) -> void:
	TransitionManager.transition()
	await TransitionManager.transition_finished
	
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s := ResourceLoader.load(path) as PackedScene
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func goto_packed_scene(scene: PackedScene) -> void:
	TransitionManager.transition()
	await TransitionManager.transition_finished
	
	var run := func() -> void:
		current_scene.free()
		current_scene = scene.instantiate()
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
	
	run.call_deferred()
	
#endregion
