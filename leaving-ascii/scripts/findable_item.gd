extends Node3D
@export var mesh: MeshInstance3D
@export var material: Material
@export var body: PhysicsBody3D
@export var dialogue: DialogueResource
var found = false

func _ready() -> void:
	#gameManager
	if body:
		body.mouse_entered.connect(show_material)
		body.mouse_exited.connect(hide_material)
		body.input_event.connect(find_object)

func show_material() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and !found:
		mesh.material_overlay = material
	
func find_object(_camera, event, _position, _normal, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			if !found:
				mesh.material_override = null
				found = true
				Events.objectFound.emit(self, dialogue)
			
func hide_material() -> void:
	if !found:
		mesh.material_overlay = null
		
