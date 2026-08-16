extends Node

@export var player : Node
@export var camera : Node
var objectsFound = 0

func _ready() -> void:
	Events.objectFound.connect(findObject)
	
func findObject(object, dialogue):
	var center = camera.global_position - camera.global_transform.basis.z * 6

	var tween = create_tween()
	tween.tween_property(object, "global_position", center, 0.5)
	tween.parallel().tween_property(object, "rotation", Vector3(0,-180,0), 0.5)
	await(tween.finished)
	await(1)
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	
	
