extends "res://scripts/character.gd"

# == VARIABLES ==============================

# TODO might change to blood in liters idk yet
@export var health : int = 100

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
