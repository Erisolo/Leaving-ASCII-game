extends Node3D

@export var mesh: MeshInstance3D
@export var material: Material
@export var body: PhysicsBody3D

func _ready() -> void:
	if body:
		body.mouse_entered.connect(show_material)
		body.mouse_exited.connect(hide_material)

func show_material() -> void:
	mesh.material_overlay = material


func hide_material() -> void:
	mesh.material_overlay = null
