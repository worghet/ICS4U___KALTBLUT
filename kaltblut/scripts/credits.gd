extends Control


func _ready() -> void:
	#$scrolling.play("scroll down")
	$music.play()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main-menu.tscn")
