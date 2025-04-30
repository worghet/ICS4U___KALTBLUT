extends Control

const all_pages : Dictionary = {
	
	0 : "ENTRY_1",
	1 : "ENTRY_2",
	2 : "ENTRY_3",
	3 : "ENTRY_4",
	4 : "ENTRY_5",
	5 : "ENTRY_6",
	6 : "ENTRY_7",
	
	
}

func flip_page(page_num : int) -> void:
	pass

func testEsc() -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = !get_tree().paused
		visible = !visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	testEsc()


func _on_resume_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().paused = false
	#$".".get_tree().change_scene_to_file("res://scenes/main-menu.tscn")
	get_tree().change_scene_to_file("res://scenes/main-menu.tscn")
