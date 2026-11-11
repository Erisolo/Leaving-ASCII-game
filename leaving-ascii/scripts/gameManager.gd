extends Node

@export var chair : Node
@export var player : Node
@export var camera : Node
@export var findable_objects: Array[Node3D]
var objectsFound = 0

func _ready() -> void:
	Events.objectFound.connect(findObject)
	findable_objects[0].visible = true
	
func findObject(object, dialogue):
	objectsFound+=1
	var center = camera.global_position - camera.global_transform.basis.z * 6
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(object, "global_position", center, 0.5)
	var direction = player.global_position - center
	direction.y = 0

	var target_rotation = atan2(direction.x, direction.z)

	# Rotate exactly once while preserving final orientation
	var final_rotation = target_rotation + TAU

	tween.tween_property(object, "global_rotation", Vector3(0, final_rotation, 0), 0.5)
	await(tween.finished)
	
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	await(DialogueManager.dialogue_ended)
	
	var act_rotation = camera.global_rotation
	#girar a la silla
	direction =  player.global_position -chair.global_position
	direction.y = 0

	target_rotation = atan2(direction.x, direction.z)
	tween = create_tween()
	tween.tween_property(camera, "global_rotation", Vector3(0, target_rotation, 0), 0.5)
	await(tween.finished)
	
	DialogueManager.show_dialogue_balloon(dialogue, "chair")
	await(DialogueManager.dialogue_ended)
	
	#girar a donde estaba antes
	tween = create_tween()
	tween.tween_property(camera, "global_rotation", act_rotation, 0.5)
	await(tween.finished)
	
	#hacer chikitin
	tween = create_tween()
	tween.tween_property(object, "scale", Vector3(0, 0, 0), 0.5)
	await(tween.finished)
	object.queue_free()
	
	
	#TEMPORAL
	dialogue_finished()
	
func dialogue_finished():
	if objectsFound < len(findable_objects):
		findable_objects[objectsFound].visible = true
	else:
		pass
	
	
