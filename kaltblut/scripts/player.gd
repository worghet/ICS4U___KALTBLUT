# PLAYER SCRIPT
extends "res://scripts/character.gd"

# == CONSTANTS ==============================

const EnemyScene := preload("res://scenes/enemy.tscn")

# == VARIABLES ==============================

var head : Node3D
var camera : Camera3D 

@export var MOUSE_SENSITIVITY : float = 0.001

# == METHODS ================================

# What to do when loaded.
func _ready() -> void:
	
	# Initialize variables.
	head = $head
	camera = $head/camera
	
	
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
	
	# -- MOUSE MOVEMENT ------------------------------------------------
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		# rotate the body of the character
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# rotate head
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(75))



	if event.is_action_pressed("right_mouse_button"):
		$"head/camera/gewehr-43/animation_player".play("ads")
	elif event.is_action_released("right_mouse_button"):
		$"head/camera/gewehr-43/animation_player".play_backwards("ads")
	

	if event.is_action_pressed("left_mouse_button"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			$"head/camera/gewehr-43".fire()
		

	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# -- FOR COMBAT TESTING ---------------------------------------------

	if event.is_action_pressed("spawn_enemy"):
		var enemy_instance := EnemyScene.instantiate()
		enemy_instance.global_transform.origin += Vector3(0, 1, 0)
		get_tree().current_scene.add_child(enemy_instance)
		print("added enemy!")
