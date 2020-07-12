extends Control

export(NodePath) var manager_path
onready var manager = get_node(manager_path)

enum MODULE {
	SECURITY = 0,
	POWER_SUPPLY,
	SOFTWARE_INTEGRITY,
	COMMUNICATION
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var title = "Title"
export var description = "Description"
export(MODULE) var module = MODULE.SECURITY
var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = title
	$Description.text = description
	$Progress.value = 1
	
func _disable():
	$ModuleButton.disabled = true
	modulate.a = 0.5
	
func _enable():
	$ModuleButton.disabled = false
	modulate.a = 1
	
func _button_press():
	if module == MODULE.SECURITY:
		manager.open_captcha_game(module)
	elif module == MODULE.SOFTWARE_INTEGRITY:		
		randomize()
		if randf() <= 0.5:
			manager.open_button_mash_game(module, module)
		else:
			manager.open_captcha_game(module)
			
	elif module == MODULE.POWER_SUPPLY:
		manager.open_space_mash_game(module)
	elif module == MODULE.COMMUNICATION:
		
		randomize()
		if randf() <= 0.5:
			manager.open_button_mash_game(module, module)
		else:
			manager.open_switch_game(module)
	
func _module_update(key, sub_val):
	if key != module:
		return
	
	$Progress.value = sub_val
	
	if sub_val == 0:
		_disable()
		disabled = true
	elif disabled:
		_enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
