extends "res://scripts/character.gd"

# == VARIABLES ==============================

# TODO might change to blood in liters idk yet
@export var health : int = 100
@export var voilence : int

var target : Node3D
@export var TURN_SPEED : float = 2.0

@onready var eyes : RayCast3D = $eyes
@onready var raycast : RayCast3D = $"gewehr-43/Sketchfab_model/cast_ray"
@onready var animation_player : AnimationPlayer = $animation_player
@onready var shoot_timer : Timer = $shoot_timer

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
		
		# Delete the enemy object from the game.
		queue_free()
	match state:
		IDLE:
			# play anim for idle
			pass
		ALERT:
			# play anim for alert
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))


func _on_sight_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("ALERT!")
		
		$"gewehr-43".enterADS()
		
		state = ALERT
		target = body
		shoot_timer.start()

func _on_sight_range_body_exited(body: Node3D) -> void:
	state = IDLE
	$"gewehr-43".stopADS()
	shoot_timer.stop()


func _on_shoot_timer_timeout() -> void:
	$"gewehr-43".fire()
	print("BANG")
