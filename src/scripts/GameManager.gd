extends Node2D

signal time_update
signal module_update
signal failure
signal survived
signal shield_level

onready var captchaPackedScene = preload("res://src/scenes/modules/module-security/CaptchaGame.tscn")
onready var buttonPackedScene = preload("res://src/scenes/modules/module-software-integrity/ModuleSoftwareItegrity.tscn")
onready var spacePackedScene = preload("res://src/scenes/modules/module-power/ModulePower.tscn")
onready var switchMiniGame = preload("res://src/scenes/modules/module-communication/ModuleCommunication.tscn")

export(float) var module_timer = 10

var currentNode = null

var module_statistics = {
	GLOBALS.MODULE.SECURITY: 1.0,
	GLOBALS.MODULE.POWER_SUPPLY: 1.0,
	GLOBALS.MODULE.SOFTWARE_INTEGRITY: 1.0,
	GLOBALS.MODULE.COMMUNICATION: 1.0,
}
var offline_modules = []
#var opening_module = GLOBALS.MODULE.SECURITY

var time_remaining : float = 300
var shield_level = 4
var start = false

export var ModuleReductionRange : Vector2 = Vector2(0.0025, 0.09)

## MAIN FUNCTIONS
func _ready() -> void:
	pass

func _start() -> void:
	$Timer.wait_time = module_timer
	$Timer.start();
	start = true

func _process(delta: float) -> void:

	if !start:
		return

	time_remaining -= delta
	_update_current_time()

	if (time_remaining <=  0):
		$Timer.stop()
		emit_signal("survived")


## CONTROL FUNCTIONS
func _on_Timer_timeout() -> void:
	# TODO : Slow down ticks or lower value impact while in minigame.
	randomize()

	$Timer.wait_time = max(time_remaining/60.0, 0.5)

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
					emit_signal("shield_level", shield_level)
				emit_signal("module_update", key, 0)
			else:
				emit_signal("module_update", key, module_statistics[key])
			print_debug("%s - %1.3f" % [_module_to_string(key), module_statistics[key]])


## PUBLIC FUNCTIONS
func open_captcha_game(module : int) -> void:
	if currentNode == null:
		var difficulty = max((5 - int(time_remaining/60)) + 1, 3)

		currentNode = captchaPackedScene.instance()
		currentNode.initialise(module, difficulty)
		currentNode.connect("finished", self, "_on_captcha_closed")
		add_child(currentNode)


func open_button_mash_game(module : int) -> void:
	if currentNode == null:
		var difficulty = (5 - int(time_remaining/60)) + 1
		if difficulty > 3:
			difficulty = 3

		currentNode = buttonPackedScene.instance()
		currentNode.initialise(module, difficulty)
		currentNode.connect("finished", self, "_on_button_mash_closed")
		add_child(currentNode)


func open_space_mash_game(module : int) -> void:
	if currentNode == null:
		currentNode = spacePackedScene.instance()
		currentNode.initialise(module)
		currentNode.connect("finished", self, "_on_space_mash_closed")
		add_child(currentNode)


func open_switch_game(module : int) -> void:
	if currentNode == null:
		currentNode = switchMiniGame.instance()
		currentNode.initialise(module)
		currentNode.connect("finished", self, "_on_switch_closed")
		add_child(currentNode)


## GLOBALS.MODULE FUNCTIONS
func _on_captcha_closed(window_result : int, data_dict : Dictionary) -> void:
	if window_result == ModuleWindowCore.WINDOW_RESULT.SUBMIT:
		var module = data_dict["module"]
		var value = data_dict["value"]
		remove_child(currentNode)
		currentNode = null

		if value:
			module_statistics[module] += 0.25
		else:
			module_statistics[module] -= 0.35
		emit_signal("module_update", module, module_statistics[module])


func _on_button_mash_closed(window_result : int, data_dict : Dictionary) -> void:
	remove_child(currentNode)
	currentNode = null
	var module = data_dict["module"]
	var value = data_dict["value"]

	if value:
		module_statistics[module] += 0.25
	else:
		module_statistics[module] -= 0.35
	emit_signal("module_update", module, module_statistics[module])


func _on_space_mash_closed(window_result : int, data_dict : Dictionary) -> void:
	if window_result == ModuleWindowCore.WINDOW_RESULT.SUBMIT:
		var module = data_dict["module"]
		var value = data_dict["value"]

		remove_child(currentNode)
		currentNode = null

		module_statistics[module] += value
		module_statistics[module] = min(100, module_statistics[module])
		emit_signal("module_update", module, module_statistics[module])


func _on_switch_closed(window_result : int, data_dict : Dictionary) -> void:
	remove_child(currentNode)
	currentNode = null
	var module = data_dict["module"]
	var value = data_dict["value"]

	if value:
		module_statistics[module] += 0.25
	else:
		module_statistics[module] -= 0.35
	emit_signal("module_update", module, module_statistics[module])

## HELPER FUNCTIONS
func _module_to_string(value : int) -> String:
	if (value == GLOBALS.MODULE.SECURITY):
		return "Security"
	elif (value == GLOBALS.MODULE.POWER_SUPPLY):
		return "Power"
	elif (value == GLOBALS.MODULE.SOFTWARE_INTEGRITY):
		return "Software"
	elif (value == GLOBALS.MODULE.COMMUNICATION):
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


func _on_AnimationController_animation_ended():
	_start()
