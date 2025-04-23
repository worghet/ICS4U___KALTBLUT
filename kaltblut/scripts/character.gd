extends CharacterBody3D

# == VARIABLES ==========================

# Movement speed.
@export var movement_speed: float = 10.0

# Jump force.
@export var jump_force: float = 5.0

# How much gravity affects the character.
@export var gravity: float = -9.8

# == METHODS [TO BE OVERRIDEN] =============

# [KEEP] All the physics-related stuff gets calculated here.
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_process_movement(delta)
	# _process_additional_physics(delta) <-- Create method if needed.
	move_and_slide()

# [OVERRIDE] All the other stuff (gunshots, animations, ui) is here.
func _process(delta: float) -> void:
	pass

# [OVERRIDE] Process the movement of the character.
func _process_movement(delta: float) -> void:
	pass

# [KEEP] Gravity applies to all characters.	
func _apply_gravity(delta : float) -> void:
	
	# If the character is not on the ground.
	if not is_on_floor():

		# Apply gravity (w/ respect to delta).
		velocity.y += delta * gravity
