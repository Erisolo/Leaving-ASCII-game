extends Node3D

@export var player : CharacterBody3D
@export var y_billboard = false
@export var inverse = false

func _process(_delta : float) -> void:
	look_at(player.global_position, Vector3.UP, inverse)
	if not y_billboard:
		rotation.x = .0
		rotation.z = .0
