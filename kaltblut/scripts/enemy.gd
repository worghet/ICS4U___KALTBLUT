extends "res://scripts/character.gd"

# might change to blood in liters idk yet
@export var health : int = 200

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if health <= 0:
		
		# delete from game
		queue_free()
