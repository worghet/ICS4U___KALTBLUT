extends "res://scripts/character.gd"

# == VARIABLES ==============================

# TODO might change to blood in liters idk yet
@export var health : int = 60
@export var voilence : int

var target : Node3D
@export var TURN_SPEED : float = 1.4

@onready var eyes : RayCast3D = $eyes
@onready var raycast : RayCast3D = $"gewehr-43/Sketchfab_model/cast_ray"
@onready var animation_player : AnimationPlayer = $animation_player
@onready var shoot_timer : Timer = $shoot_timer






@export var player_path : Node3D
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D



enum {
	IDLE,
	ALERT,
}

var state : int = IDLE

# == METHODS ================================

# What to do when loaded.
func _ready() -> void:
	pass
# What to process each frame.
func _process(delta: float) -> void:
	
	# If the health reaches 0 or less than 0.
	if health <= 0:
		
		$anim_soldier/AnimationPlayer.play("death")
		$"gewehr-43".hide()
		await get_tree().create_timer(0.78).timeout
		# Delete the enemy object from the game.
		queue_free()
		
	velocity = Vector3.ZERO
	match state:
		IDLE:
			# play anim for idle
			
			pass
		ALERT:

			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED)) 
			navigation_agent.set_target_position(target.global_transform.origin)
			var next_nav_point := navigation_agent.get_next_path_position()

			# Calculate horizontal movement direction only
			var direction := next_nav_point - global_transform.origin
			direction.y = 0  # Zero out the vertical component of the direction

			if navigation_agent.distance_to_target() > 10:
				velocity = direction.normalized() * movement_speed * 0.3
				# You can also play the running animation if you want
				# $anim_soldier/AnimationPlayer.play_section("run_forward", 0, 0.25, -1, 0.2)
			elif navigation_agent.distance_to_target() == 10:
				pass
			else:
				velocity = -direction.normalized() * movement_speed * 0.3

			# Apply the movement
			move_and_slide()



func _on_sight_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("ALERT!")
		
		$"gewehr-43".enterADS()
		
		state = ALERT
		target = body
		shoot_timer.start()
		$anim_soldier/AnimationPlayer.play_backwards("rifle down")
		

func _on_sight_range_body_exited(body: Node3D) -> void:
	state = IDLE
	$"gewehr-43".stopADS()
	shoot_timer.stop()
	$anim_soldier/AnimationPlayer.play("idle")
	


func _on_shoot_timer_timeout() -> void:
	$"gewehr-43".fire()
	$anim_soldier/AnimationPlayer.play("fire")
	#print("BANG")

func set_path(player : Node3D) -> void:
	player_path = player
