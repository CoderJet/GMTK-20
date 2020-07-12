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

signal power_stolen
signal finished

var current_country = COUNTRY.AFRICA
var power_level : float = 0.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_node("Countries/ButtonAfrica").set_pressed(true)
	pass


func _on_ButtonAfrica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.AFRICA

	if button_pressed:
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)



func _on_ButtonAsia_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.ASIA

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonEurope_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.EUROPE

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonNorthAmerica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.NORTH_AMERICA

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonSouthAmerica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.SOUTH_AMERICA

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonAntartica_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.ANTARTICA

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAustralia").set_pressed(false)


func _on_ButtonAustralia_toggled(button_pressed: bool) -> void:
	current_country = COUNTRY.AUSTRALIA

	if button_pressed:
		get_node("Countries/ButtonAfrica").set_pressed(false)
		get_node("Countries/ButtonAsia").set_pressed(false)
		get_node("Countries/ButtonEurope").set_pressed(false)
		get_node("Countries/ButtonNorthAmerica").set_pressed(false)
		get_node("Countries/ButtonSouthAmerica").set_pressed(false)
		get_node("Countries/ButtonAntartica").set_pressed(false)


func _on_ButtonDivertPower_pressed() -> void:
	# Different countries will provide different returned energy,
	# but doing so will piss the country off.
	var value = 0

	if (current_country == COUNTRY.AFRICA):
		value = 0.0025
	elif (current_country == COUNTRY.ASIA):
		value = 0.011
	elif (current_country == COUNTRY.EUROPE):
		value = 0.009
	elif (current_country == COUNTRY.NORTH_AMERICA):
		value = 0.01
	elif (current_country == COUNTRY.SOUTH_AMERICA):
		value = 0.0025
	elif (current_country == COUNTRY.ANTARTICA):
		value = 0.0025
	elif (current_country == COUNTRY.AUSTRALIA):
		value = 0.0055
	power_level += value
	emit_signal("power_stolen", current_country, value)

	var power_whole = int(power_level * 100)

	get_node("PowerLevel").value = power_whole
	get_node("PowerLevel/PowerPercentage").text = String(power_whole) + "%"
