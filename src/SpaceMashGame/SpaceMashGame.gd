extends Control

enum COUNTRY {
	AFRICA = 0,
	ASIA,
	EUROPE,
	NORTH_AMERICA,
	SOUTH_AMERICA,
	ANTARTICA,
	AUSTRALIA
}

signal success
signal failure

var current_country = COUNTRY.AFRICA
var current_focus = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_node("Countries/ButtonAfrica").set_pressed(true)
	pass


func _on_ButtonAfrica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.AFRICA
	print("_on_ButtonAfrica_toggled")

	get_node("Countries/ButtonAsia").set_pressed(false)
	get_node("Countries/ButtonEurope").set_pressed(false)
	get_node("Countries/ButtonNorthAmerica").set_pressed(false)
	get_node("Countries/ButtonSouthAmerica").set_pressed(false)
	get_node("Countries/ButtonAntartica").set_pressed(false)
	get_node("Countries/ButtonAustralia").set_pressed(false)



func _on_ButtonAsia_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.ASIA

	get_node("Countries/ButtonAfrica").set_pressed(false)
	get_node("Countries/ButtonEurope").set_pressed(false)
	get_node("Countries/ButtonNorthAmerica").set_pressed(false)
	get_node("Countries/ButtonSouthAmerica").set_pressed(false)
	get_node("Countries/ButtonAntartica").set_pressed(false)
	get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonEurope_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.EUROPE


func _on_ButtonNorthAmerica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.NORTH_AMERICA


func _on_ButtonSouthAmerica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.SOUTH_AMERICA


func _on_ButtonAntartica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.ANTARTICA


func _on_ButtonAustralia_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.AUSTRALIA


func _on_ButtonDivertPower_pressed() -> void:
	current_focus.grab_focus()
