extends "res://scripts/character.gd"

# == VARIABLES ==============================

var head : Node3D
var camera : Camera3D 

# == METHODS ================================

# What to do when loaded.
func _ready() -> void:
	
	# Initialize variables.
	head = $head
	camera = $head/camera
	
	# Set mouse mode to reading.
	
func _process_movement(delta: float) -> void:
	
	# -- PROCESS JUMP ------------------------------
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_force
	
	# -- PROCESS MOVEMENT --------------------------
	
	# Get a Vector2D of the WASD mapping of the keys pressed in this frame.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	# Convert the input direction (Vector2D) to a Vector3D based on the character's orientation in 3D space.
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# If direction is a value which is not 0.
	if direction:
		velocity.z = direction.z * movement_speed
		velocity.x = direction.x * movement_speed
	
	# If direction is zero (no inputs of WASD have been pressed).
	else:
		velocity.z = 0.0
		velocity.x = 0.0
		
func _input(event: InputEvent) -> void:
	pass

func _process_movement_input(event: InputEvent) -> void:
	pass
