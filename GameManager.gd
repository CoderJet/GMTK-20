extends Node2D

enum MODULE {
	SECURITY = 0,
	POWER_SUPPLY,
	SOFTWARE_INTEGRITY,
	COMMUNICATION
}

signal time_update
signal module_update
signal failure
signal survived

onready var captchaPackedScene = preload("res://src/CaptchaGame/CaptchaGame.tscn")
onready var buttonPackedScene = preload("res://src/ButtonMashGame/ButtonMashGame.tscn")
onready var spacePackedScene = preload("res://src/SpaceMashGame/SpaceMashGame.tscn")
onready var switchMiniGame = preload("res://src/SwitchMiniGame/SwitchMiniGame.tscn")

var currentNode = null

var module_statistics = {
	MODULE.SECURITY: 1.0,
	MODULE.POWER_SUPPLY: 1.0,
	MODULE.SOFTWARE_INTEGRITY: 1.0,
	MODULE.COMMUNICATION: 1.0,
}
var offline_modules = []

var time_remaining : float = 300
var shield_level = 3

export var ModuleReductionRange : Vector2 = Vector2(0.0025, 0.09)

## MAIN FUNCTIONS
func _ready() -> void:
	$Timer.start();


func _process(delta: float) -> void:
	time_remaining -= delta
	_update_current_time()

	if (time_remaining <=  0):
		$Timer.stop()
		emit_signal("survived")



func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_1 and event.pressed:
		open_button_mash_game(MODULE.SOFTWARE_INTEGRITY)
	elif event.scancode == KEY_2 and event.pressed:
		open_button_mash_game(MODULE.COMMUNICATION)
	elif event.scancode == KEY_3 and event.pressed:
		open_captcha_game()
	elif event.scancode == KEY_4 and event.pressed:
		open_switch_game()

## CONTROL FUNCTIONS
func _on_Timer_timeout() -> void:
	# TODO : Slow down ticks or lower value impact while in minigame.
	for key in module_statistics:
		if key in offline_modules:
			continue

		randomize()
		if (randf() <= 0.5):
			module_statistics[key] -= rand_range(ModuleReductionRange.x, ModuleReductionRange.y)

			if module_statistics[key] <= 0:
				shield_level -= 1
				offline_modules.append(key)
				if shield_level == 0:
					emit_signal("failure")
			else:
				emit_signal("module_update", module_statistics[key])
			print_debug("%s - %1.3f" % [_module_to_string(key), module_statistics[key]])


## PUBLIC FUNCTIONS
func open_captcha_game() -> void:
	if currentNode == null:
		currentNode = captchaPackedScene.instance()
		currentNode.connect("finished", self, "_on_captcha_closed")
		add_child(currentNode)


func open_button_mash_game(module : int) -> void:
	if currentNode == null:
		currentNode = buttonPackedScene.instance()

		if module == MODULE.SOFTWARE_INTEGRITY:
			currentNode.initiate_minigame(currentNode.FILE_TYPE.CODE)
		else:
			randomize()

			if randf() <= 0.5:
				currentNode.initiate_minigame(currentNode.FILE_TYPE.EMAIL)
			else:
				currentNode.initiate_minigame(currentNode.FILE_TYPE.RECIPE)

		currentNode.connect("finished", self, "_on_button_closed")
		add_child(currentNode)


func open_space_mash_game(module : int) -> void:
	if currentNode == null:
		currentNode = buttonPackedScene.instance()
		currentNode.connect("finished", self, "_on_space_closed")
		add_child(currentNode)


func open_switch_game() -> void:
	if currentNode == null:
		currentNode = switchMiniGame.instance()
		randomize()

		if randf() > 0.25:
			currentNode.initiate_minigame(currentNode.CALL_TYPE.WORK)
		else:
			currentNode.initiate_minigame(currentNode.CALL_TYPE.PERSONAL)

		currentNode.connect("finished", self, "_on_switch_closed")
		add_child(currentNode)


## MODULE FUNCTIONS
func _on_captcha_closed(value : bool) -> void:
	remove_child(currentNode)
	currentNode = null

	if value:
		module_statistics[MODULE.SECURITY] += 0.25
	else:
		module_statistics[MODULE.SECURITY] -= 0.35
	emit_signal("module_update", module_statistics[MODULE.SECURITY])


func _on_button_mash_closed(value : bool, module : int) -> void:
	remove_child(currentNode)
	currentNode = null

	if value:
		module_statistics[module] += 0.25
	else:
		module_statistics[module] -= 0.35
	emit_signal("module_update", module_statistics[module])


func _on_space_mash_closed(value : bool) -> void:
	remove_child(currentNode)
	currentNode = null

	if value:
		module_statistics[MODULE.POWER_SUPPLY] += 0.25
	else:
		module_statistics[MODULE.POWER_SUPPLY] -= 0.35
	emit_signal("module_update", module_statistics[MODULE.POWER_SUPPLY])


func _on_switch_closed(value : bool) -> void:
	remove_child(currentNode)
	currentNode = null

	if value:
		module_statistics[MODULE.COMMUNICATION] += 0.25
	else:
		module_statistics[MODULE.COMMUNICATION] -= 0.35
	emit_signal("module_update", module_statistics[MODULE.COMMUNICATION])

## HELPER FUNCTIONS
func _module_to_string(value : int) -> String:
	if (value == MODULE.SECURITY):
		return "Security"
	elif (value == MODULE.POWER_SUPPLY):
		return "Power"
	elif (value == MODULE.SOFTWARE_INTEGRITY):
		return "Software"
	elif (value == MODULE.COMMUNICATION):
		return "Comms"
	return "UNKNOWN"


func _update_current_time() -> void:
	var mins = int(time_remaining / 60)
	var secs = int(time_remaining) % 60
	var mSecs = 0

	var a = stepify(float(time_remaining), 0.001)
	var b = String(a).split('.')

	if b.size() == 2:
		mSecs = int(b[1])
	emit_signal("time_update", "%02d:%02d:%03d" % [mins, secs, mSecs])
