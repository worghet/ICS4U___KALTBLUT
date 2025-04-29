extends Control

func _ready() -> void:
	pass

enum {
	ENGLISH,
	RUSSIAN,
	SPANISH,
	FRENCH,
	GERMAN
}

var LANGUAGE : String = TranslationServer.get_locale()

func _on_button_2_pressed() -> void:
	$CenterContainer/GridContainer/Label.text = tr("GREETING")


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
