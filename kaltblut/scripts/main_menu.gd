extends Control

func _ready() -> void:
	print('donezo')
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	

func _on_quit_pressed() -> void:
	get_tree().quit()
