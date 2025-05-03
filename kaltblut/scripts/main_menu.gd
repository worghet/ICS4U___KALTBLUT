extends Control	

func _on_play_pressed() -> void:
	print('play pressed')
	get_tree().change_scene_to_file("res://scenes/gameplay/world.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	print('goin to credoits')
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")
	


func _on_settings_pressed() -> void:
	$settings.visible = true

func _process(delta: float) -> void:
	if $settings.visible:
		$menu.visible = false
	else:
		$menu.visible = true
