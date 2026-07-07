extends AnimationPlayer

@export var player : CharacterBody3D
var moving := false
var non_zero_speed := 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Idle")

func _physics_process(_delta: float) -> void:
	if player.velocity.length() > non_zero_speed and not moving: 
		moving = true
		play("Walk")
	
	elif moving and player.velocity.length() < non_zero_speed:
		moving = false
		play("Idle")
