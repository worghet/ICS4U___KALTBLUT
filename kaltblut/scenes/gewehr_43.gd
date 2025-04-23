extends Node3D


@export var damage : float = 50

@onready var aimcast := $Sketchfab_model/aimcast


func fire() -> void:
	if aimcast.is_colliding() and aimcast.get_collider() is CharacterBody3D:
		var target : CharacterBody3D = aimcast.get_collider()
		if target.is_in_group("enemies"):
			print("enemy his")
			target.health -= damage
	$animation_player.play("fire")


func ads() -> void:
	$animation_player.play("ads")
