extends Node3D


var footstep_sounds : Array = [
	preload("res://imports/sounds/steps/Step_1.mp3"),
	preload("res://imports/sounds/steps/Step_2.mp3"),
	preload("res://imports/sounds/steps/Step_3.mp3"),
	preload("res://imports/sounds/steps/Step_4.mp3"),
	preload("res://imports/sounds/steps/Step_5.mp3")
]

func step() -> void:
	$footsteps_sound.stream = footstep_sounds[randi() % footstep_sounds.size()]
	$footsteps_sound.play()
		


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#$AnimationPlayer.stop()
