extends Control


enum {
	ENGLISH,
	RUSSIAN,
	SPANISH,
	FRENCH,
	GERMAN
}

var LANGUAGE : String = TranslationServer.get_locale()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		visible = false




func _on_language_pressed() -> void:
	$"center-container/up-down/left-right/setting_panel/video".visible = false
	
	$"center-container/up-down/left-right/setting_panel/language".visible = true
	

func _on_back_pressed() -> void:
	visible = false


func _on_video_pressed() -> void:
	$"center-container/up-down/left-right/setting_panel/language".visible = false
	$"center-container/up-down/left-right/setting_panel/video".visible = true
	


func _on_audio_pressed() -> void:
	pass # Replace with function body.


func _on_option_button_item_selected(index: int) -> void:
	match index:
		# optimize w dictionary
		ENGLISH: LANGUAGE = "en"
		RUSSIAN: LANGUAGE = "ru"
		SPANISH: LANGUAGE = "es"	
		FRENCH: LANGUAGE = "fr"
		GERMAN: LANGUAGE = "ge"
		
	print("lang changed to " + LANGUAGE)
	TranslationServer.set_locale(LANGUAGE)
