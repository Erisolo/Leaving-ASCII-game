class_name Player extends CharacterBody3D

@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 

@export var camera: Camera3D

func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera_from_mouse()
	if Input.is_action_just_pressed("esc"): 
		if mouse_captured: release_mouse()
		else: capture_mouse()

func _physics_process(delta: float) -> void:
	velocity = _walk(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _rotate_camera_from_mouse() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var center := viewport_size / 2.0
	var mouse_pos := get_viewport().get_mouse_position()

	var offset := mouse_pos - center

	# Don't rotate if the mouse is basically centered.
	if offset.length() < 1.0:
		return

	var sensitivity := camera_sens * 0.002

	camera.rotation.y -= offset.x * sensitivity
	camera.rotation.x -= offset.y * sensitivity
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

	# Put the cursor back in the center.
	Input.warp_mouse(center)

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel
