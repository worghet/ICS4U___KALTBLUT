extends Node3D

#func _process(delta: float) -> void:
var inPause : bool = false
var inSett : bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if $pause.visible:
		inPause = true
		inSett = false
	elif $setting.visible:
		inSett = true
		inPause = false
	else:
		inSett = false
		inPause = false	
	
	$pause.visible = inPause
	$setting.visible = inSett
