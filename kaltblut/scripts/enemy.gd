extends "res://scripts/character.gd"

# == VARIABLES ==============================

# TODO might change to blood in liters idk yet
@export var violence : int

var target : Node3D

var health : int = 60
var TURN_SPEED : float = 3
var FIRE_RATE : float = 1 # in seconds
var RANGE_OF_FIRE: float = 5

@onready var eyes : RayCast3D = $eyes
@onready var raycast : RayCast3D = $"gewehr-43/Sketchfab_model/cast_ray"
@onready var animation_player : AnimationPlayer = $animation_player
@onready var shoot_timer : Timer = $shoot_timer


const enemy_screams : Array = [
	
	preload("res://imports/sounds/enemy-scream/EnemyScream_1.mp3"),
	preload("res://imports/sounds/enemy-scream/EnemyScream_2.mp3"),
	preload("res://imports/sounds/enemy-scream/EnemyScream_3.mp3"),
	preload("res://imports/sounds/enemy-scream/EnemyScream_4.mp3")
	
]

const ding := preload("res://imports/sounds/ui/NewEntry.mp3")


@export var player_path : Node3D
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D



enum {

	# Attacking or not attacking
	IDLE,
	ALERT,
	
	# Violence Level
	PASSIVE, 
	SUSPICIOUS,
	AWARE,
	AGGRESSIVE,
	DEADLY
}

var state : int = IDLE
var isAlive : bool = true
var last_step_time := 0.0  # To track the last time a step was taken
var step_interval : float = randf_range(0.5, 1.5)  # Randomized step interval between 0.5 and 1.5 seconds


# == METHODS ================================

# What to do when loaded.
func _ready() -> void:
	match violence:
		
		PASSIVE:
			shoot_timer.queue_free()
		SUSPICIOUS:
			shoot_timer.queue_free()
			RANGE_OF_FIRE = 2
		AWARE:
			pass
		AGGRESSIVE:
			pass
		DEADLY:
			pass
			

	
var prevH : int = health
# What to process each frame.
func _process(delta: float) -> void:
	
		if health < prevH:
			arrrg()
		prevH = health
	
	
		velocity = Vector3.ZERO
		# If the health reaches 0 or less than 0.
		if health <= 0:
			
			$anim_soldier/AnimationPlayer.play("death")
			$"gewehr-43".hide()
			await get_tree().create_timer(1.2).timeout
			queue_free()
			
			# technically not needed
			return
			
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

				if navigation_agent.distance_to_target() > RANGE_OF_FIRE:
					velocity = direction.normalized() * movement_speed * 0.3
					# You can also play the running animation if you want
					# $anim_soldier/AnimationPlayer.play_section("run_forward", 0, 0.25, -1, 0.2)
					await get_tree().create_timer(0.78).timeout
					$anim_soldier.step()

					
				elif RANGE_OF_FIRE + 0.2 > navigation_agent.distance_to_target() and navigation_agent.distance_to_target() > RANGE_OF_FIRE - 0.2 :
					velocity = Vector3.ZERO
				else:
					velocity = -direction.normalized() * movement_speed * 0.3
					await get_tree().create_timer(0.78).timeout
					
					$anim_soldier.step()

				# Apply the movement
				move_and_slide()



func _on_sight_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):

		if violence != PASSIVE:		
			$"gewehr-43".enterADS()
			
			$anim_soldier/AnimationPlayer.play_backwards("rifle down")
			state = ALERT
			target = body

			if violence != SUSPICIOUS:
				shoot_timer.start()	
		

func _on_sight_range_body_exited(body: Node3D) -> void:

	if violence != PASSIVE:
		state = IDLE
		$"gewehr-43".stopADS()
		$anim_soldier/AnimationPlayer.play("idle")
		
		if violence != SUSPICIOUS:
			shoot_timer.stop()
	


func _on_shoot_timer_timeout() -> void:
	$"gewehr-43".fire()
	$anim_soldier/AnimationPlayer.play("fire")
	#print("BANG")

func set_path(player : Node3D) -> void:
	player_path = player
	
func set_violence(violence_level : int) -> void:
	violence = violence_level

func arrrg() -> void:
	$arg.stream = enemy_screams[randi() % enemy_screams.size()]
	$arg.play()
	#await get_tree().create_timer(0.5).timeout
	#$arg.stop()
