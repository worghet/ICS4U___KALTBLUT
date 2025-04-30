extends Control

@onready var audio : AudioStreamPlayer = $audio
const page_flip := preload("res://imports/sounds/ui/PageFlip.mp3")
const open := preload("res://imports/sounds/ui/BookOpen.mp3")
const close := preload("res://imports/sounds/ui/BookClose.mp3")



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
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(delta: float) -> void:
	testEsc()


func _ready() -> void:
	audio.stream = close
	audio.play()

func _on_resume_pressed() -> void:
	resume()

func resume() -> void:
	audio.stream = close
	audio.play()
	
	get_tree().paused = false
	visible = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause() -> void:
	audio.stream = open
	audio.play()
	
	get_tree().paused = true
	visible = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_settings_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
	


func _on_quit_pressed() -> void:
	get_tree().paused = false
	#$".".get_tree().change_scene_to_file("res://scenes/main-menu.tscn")
	get_tree().change_scene_to_file("res://scenes/main-menu.tscn")


func _on_next_page_pressed() -> void:
	audio.stream = page_flip
	audio.play()


func _on_prev_page_pressed() -> void:
	audio.stream = page_flip
	audio.play()
