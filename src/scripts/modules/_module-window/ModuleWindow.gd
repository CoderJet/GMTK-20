extends NinePatchRect
class_name ModuleWindow
## Properties
onready var window_title = $WindowTitle setget _set_window_title
onready var flavour_text = $FlavourText setget _set_window_flavour_text


func _set_window_title(value : String) -> void:
	window_title.text = value


func _set_window_flavour_text(value : String) -> void:
	flavour_text.text = value
