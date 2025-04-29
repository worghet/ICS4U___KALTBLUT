extends "res://scripts/character.gd"

# == CONSTANTS ==============================

const EnemyScene := preload("res://scenes/enemy.tscn")

# == VARIABLES ==============================

var head : Node3D
var camera : Camera3D 
var rifle : Node3D


const BOB_FREQUENCY : float = 1.5
const BOB_AMPLITUDE : float = 0.075
var bob_x : float = 0.0
var health := 100

@export var MOUSE_SENSITIVITY : float = 0.001
#@export var CAMERA_FOV : float = 75.0

# == METHODS ================================

# What to do when loaded.
func _ready() -> void:
	
	# Initialize variables.
	head = $anim_soldier/head
	camera = $anim_soldier/head/camera
	rifle = $anim_soldier/head/camera/rifle
	$heal_timer.start()
		
		
func _process(delta: float) -> void:
	
	# DEATH
	if health == 100:
		$Control/BloodOverlay.visible = false
	
	else:
		$Control/BloodOverlay.visible = true
		
		if health < 80:
			$Control/BloodOverlay.modulate.a = 0.1
		if health < 60:
			$Control/BloodOverlay.modulate.a = 0.3
		if health < 40:
			$Control/BloodOverlay.modulate.a = 0.5
		if health <= 0:
			#$anim_soldier/AnimationPlayer.play("death")
			$anim_soldier.hide()
			camera.rotate_x(0.009)
			rifle.hide()
			await get_tree().create_timer(1).timeout
			# Delete the enemy object from the game.
			get_tree().reload_current_scene()
		
# What to do regarding movement each frame.
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
		
		if rifle.isADS():
			velocity.z = direction.z * movement_speed * 0.6
			velocity.x = direction.x * movement_speed * 0.6
		else:
			velocity.z = direction.z * movement_speed
			velocity.x = direction.x * movement_speed						

		
		bob_x += delta * velocity.length() * float(is_on_floor())
		$anim_soldier.transform.origin = _headbob(bob_x)
		
	
	# If direction is zero (no inputs of WASD have been pressed).
	else:
		velocity.z = 0.0
		velocity.x = 0.0
		#$anim_soldier.transform.origin.y = -0.15


# How to handle set inputs.
func _input(event: InputEvent) -> void:
	
	# -- MOUSE ACTION ------------------------------------------------
	
	# If the mouse was moved, and the screen was in "focused" mode.
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		
		# Rotate the BODY of the player in relation to the horizontal movement of the mouse.
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotate the CAMERA of the player in relation to the vertical movement of the mouse.
		#camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(75))

	# If the right mouse button is pressed, enter ADS; if released, exit it.
	if event.is_action_pressed("right_mouse_button"):
		rifle.enterADS()
		$anim_soldier/AnimationPlayer.play_backwards("rifle down")
	elif event.is_action_released("right_mouse_button"):
		rifle.stopADS()

		
		$anim_soldier/AnimationPlayer.play("rifle down")
		
	
	# Check if the left mouse button was pressed.
	if event.is_action_pressed("left_mouse_button"):
		
		# If the game window is not currently focused; focus it.
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		# Otherwise, fire the rifle.
		else:
			if rifle.isADS():
				if rifle.canShoot():
					rifle.fire()	
					$anim_soldier/AnimationPlayer.play("fire")

	# -- CHECK OTHER KEYS --------------------------------------------

	# Check if the escape key was pressed.
	#if event.is_action_pressed("escape"):
		#get_tree().paused = !get_tree().paused
		#print("changed state to pause/unpause")
		
		# Make the cursor visible.
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



	# -- FOR COMBAT TESTING ---------------------------------------------



	if event.is_action_pressed("spawn_enemy"):
		var enemy_instance := EnemyScene.instantiate()
		enemy_instance.set_path($player)
		enemy_instance.set_violence(4)
		enemy_instance.global_transform.origin += Vector3(0, 1, 0)
		get_tree().current_scene.add_child(enemy_instance)
		print("added enemy!")



func _headbob(time : float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE - 0.3
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	var target_y := -BOB_AMPLITUDE - 0.3
	var epsilon := 0.01  # Small tolerance for floating-point comparison
	if abs(pos.y - target_y) < epsilon:
		print("step called1")
		$anim_soldier.step()
	#if pos.y == -BOB_AMPLITUDE:
	
	return pos


func _on_heal_timer_timeout() -> void:
	if health < 100:
		health += 20
