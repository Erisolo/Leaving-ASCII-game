extends Node3D

@export var mesh: MeshInstance3D
@export var material: Material
@export var body: PhysicsBody3D
@export var dialogue: DialogueResource
var dialoguing : bool = false

func _ready() -> void:
	if body:
		body.mouse_entered.connect(show_material)
		body.mouse_exited.connect(hide_material)
		body.input_event.connect(show_dialogue)
		DialogueManager.dialogue_ended.connect(closed_dialogue)

func show_material() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		mesh.material_overlay = material
	
func show_dialogue(_camera, event, _position, _normal, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			dialoguing = true
			DialogueManager.show_dialogue_balloon(dialogue, "start")
			
func hide_material() -> void:
	if !dialoguing and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		mesh.material_overlay = null
		
func closed_dialogue(dialogue_ended) -> void:
	if dialogue_ended == dialogue:
		dialoguing = false
