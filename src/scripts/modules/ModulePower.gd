extends ModuleWindowCore

onready var window = get_node("Window")
onready var power_from = get_node("Window/PowerFrom")
onready var power_to = get_node("Window/PowerTo")
onready var power_perc = get_node("Window/PowerLevel/PowerPercentage")

# TODO: Change window to use a power slider
const CONTINENT_POWERS = {
	GLOBALS.CONTINENT.AFRICA 			: 0.20,
	GLOBALS.CONTINENT.ANTARTICA 		: 0.15,
	GLOBALS.CONTINENT.ASIA 				: 0.55,
	GLOBALS.CONTINENT.AUSTRALIA 		: 0.35,
	GLOBALS.CONTINENT.EUROPE 			: 0.45,
	GLOBALS.CONTINENT.NORTH_AMERICA 	: 0.50,
	GLOBALS.CONTINENT.SOUTH_AMERICA 	: 0.25,
}

var from_country = GLOBALS.CONTINENT.AFRICA
var prev_from_country = GLOBALS.CONTINENT.AFRICA
var from_validating := false

var to_country = GLOBALS.CONTINENT.SOUTH_AMERICA
var prev_to_country = GLOBALS.CONTINENT.SOUTH_AMERICA
var to_validating := false

var power_level : float = 0.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window.window_title = "Power Relocation"
	window.flavour_text = "Select a continent to transfer power from, this may affect relations with them."
	_update_power_percentage(CONTINENT_POWERS[from_country])
	get_node("Window/ButtonDivertPower").grab_focus()

	yield(perform_opening_animation(), "completed")


func _update_power_percentage(value : float) -> void:
	power_perc.text = "+%d%s" % [value * 100.0, "%"]


func _power_from_toggler(button_pressed: bool) -> void:
	if not from_validating:
		from_validating = true

		var node_to_check = power_from.get_focus_owner()
		var idx := 0

		for child in power_from.get_children():
			if button_pressed:
				if child  == node_to_check:
					if idx == to_country:
						child.set_pressed(false)
						power_from.get_children()[from_country].set_pressed(true)
						break
					else:
						from_country = idx
						_update_power_percentage(CONTINENT_POWERS[from_country])
				else:
					child.set_pressed(false)
			else:
				if idx == from_country:
					child.set_pressed(true)
					break
			idx += 1

		if prev_from_country != from_country:
			prev_from_country = from_country
		from_validating = false


func _power_to_toggler(button_pressed: bool) -> void:
	if not to_validating:
		to_validating = true

		var node_to_check = power_to.get_focus_owner()
		var idx := 0

		for child in power_to.get_children():
			if button_pressed:
				if child  == node_to_check:
					if idx == from_country:
						child.set_pressed(false)
						power_to.get_children()[to_country].set_pressed(true)
						break
					else:
						to_country = idx
				else:
					child.set_pressed(false)
			else:
				if idx == to_country:
					child.set_pressed(true)
					break
			idx += 1

		if prev_to_country != to_country:
			prev_to_country = to_country

		to_validating = false


func _on_ButtonDivertPower_pressed() -> void:
	yield(perform_closing_animation(), "completed")
	emit_signal("finished", WINDOW_RESULT.SUBMIT,
	{
		"module"	: current_module,
		"from" 		: from_country,
		"to" 		: to_country,
		"value"		: CONTINENT_POWERS[from_country],
	})
