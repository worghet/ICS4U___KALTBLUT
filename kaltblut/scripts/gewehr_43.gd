extends Node3D

# == CONSTANTS ==================================

const DAMAGE : float = 20
const RECHARGE_TIME : float = 0.35

# == VARIABLES ==================================

var can_shoot : bool = true
var ads_toggled : bool = false

var gunshot_sounds : Array = [
	preload("res://imports/sounds/rifle/RifleGunshot_1.mp3"),
	preload("res://imports/sounds/rifle/RifleGunshot_2.mp3"),
	preload("res://imports/sounds/rifle/RifleGunshot_4.mp3"),
]

# == REFERENCES TO OTHER NODES ==================

@onready var cast_ray := $Sketchfab_model/cast_ray
@onready var animation_player := $animation_player

# == METHODS ====================================


# Perform the actual shooting.
func hitscan() -> void:
	
	# If the ray cast from the barrel of the gun has collided with a CharacterBody3D.
	if cast_ray.is_colliding() and cast_ray.get_collider() is CharacterBody3D:
		
		# Save the object it collided with (not needed, but safe).
		var target : CharacterBody3D = cast_ray.get_collider()
		
		# Take away health based on rifle damage.
		target.health -= DAMAGE
		

# Shoot and play the animation.
func fire() -> void:
	# Set the gun to a recharging state.
	can_shoot = false
	if ads_toggled:
		# Perform hitscan shot.
		hitscan()
			
		# Check which state the rifle is in; and play correct animation.
		animation_player.play("ads_fire")
		
		#sound
		
		$Sketchfab_model/gunshot_sound.stream = gunshot_sounds[randi() % gunshot_sounds.size()]
		$Sketchfab_model/gunshot_sound.play()
		
		# Start a timer for a constant amount of time.
		await get_tree().create_timer(RECHARGE_TIME).timeout
			# Update the variable to allow shooting.
		can_shoot = true

# Play the animation to enter ads, update variable.
func enterADS() -> void:
	animation_player.play("ads")
	ads_toggled = true
	
# Play the animation to leave ads, update variable.
func stopADS() -> void:
	animation_player.play_backwards("ads")
	ads_toggled = false


# == GETTER METHOD ==============================


func isADS() -> bool:
	return ads_toggled

func canShoot() -> bool:
	return can_shoot
