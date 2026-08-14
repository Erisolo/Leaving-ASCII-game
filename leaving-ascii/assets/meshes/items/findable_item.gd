extends Node3D
@export var mesh: MeshInstance3D
@export var material: Material
@export var body: PhysicsBody3D
@export var dialogue: DialogueResource

func _ready() -> void:
	if body:
		body.mouse_entered.connect(show_material)
		body.mouse_exited.connect(hide_material)
		body.input_event.connect(find_object)

func show_material() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		mesh.material_overlay = material
	
func find_object(_camera, event, _position, _normal, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			pass
			
func hide_material() -> void:
	mesh.material_overlay = null
		
