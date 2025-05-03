extends Control

@onready var audio : AudioStreamPlayer = $audio
const page_flip := preload("res://imports/sounds/ui/PageFlip.mp3")
const open := preload("res://imports/sounds/ui/BookOpen.mp3")
const close := preload("res://imports/sounds/ui/BookClose.mp3")

var current_page : int = 1
var pages_collected: int = 7

const all_pages : Dictionary = {
	
	1 : "KEY_ENTRY_1",
	2 : "KEY_ENTRY_2",
	3 : "KEY_ENTRY_3",
	4 : "KEY_ENTRY_4",
	5 : "KEY_ENTRY_5",
	6 : "KEY_ENTRY_6",
	7 : "KEY_ENTRY_7",
	
	
}

# testing
	
func _ready() -> void:
	
	audio.stream = open
	audio.play()
	
	$"CenterContainer/GridContainer/left-right/PanelContainer/GridContainer/diary_section/diary_entry".text = all_pages.get(current_page)
	$"CenterContainer/GridContainer/left-right/PanelContainer/GridContainer/MarginContainer/page_navigation/page_index".text = str(current_page) + " / " + str(pages_collected)

func flip_page(page_num : int) -> void:
	if page_num <= pages_collected and page_num > 0:
		audio.stream = page_flip
		audio.play()
		current_page = page_num
		$"CenterContainer/GridContainer/left-right/PanelContainer/GridContainer/diary_section/diary_entry".text = all_pages.get(current_page)
		$"CenterContainer/GridContainer/left-right/PanelContainer/GridContainer/MarginContainer/page_navigation/page_index".text = str(current_page) + " / " + str(pages_collected)	
			
func collect_page() -> void:
	pages_collected += 1
	$"CenterContainer/GridContainer/left-right/PanelContainer/GridContainer/MarginContainer/page_navigation/page_index".text = str(current_page) + " / " + str(pages_collected)	

func testEsc() -> void:
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(delta: float) -> void:
	testEsc()


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
	

#func _on_settings_pressed() -> void:
	#get_tree().paused = false


func _on_quit_pressed() -> void:
	get_tree().paused = false
	#$".".get_tree().change_scene_to_file("res://scenes/main-menu.tscn")
	get_tree().change_scene_to_file("res://scenes/menus/main-menu.tscn")


func _on_next_page_pressed() -> void:
	flip_page(current_page + 1)



func _on_prev_page_pressed() -> void:
	flip_page(current_page - 1)
