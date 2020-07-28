extends ModuleWindowCore

enum FILE_TYPE {
	CODE = 0,
	RECIPE = 1,
	EMAIL = 2,
}

onready var window = get_node("Window")
onready var textBox = get_node("Window/TextAreaBorder/TextArea")

const CODE_PATH = "res://src/scenes/modules/module-software-integrity/Files/Code/"
const RECIPE_PATH = "res://src/scenes/modules/module-software-integrity/Files/Recipes/"
const EMAIL_PATH = "res://src/scenes/modules/module-software-integrity/Files/Emails/"

var message := String()
var key_press_count : int = 0
var current_file_type = FILE_TYPE.CODE
var initiated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window.window_title = "Integrity?"
	window.flavour_text = "Baba-baloo?"

	var path
	var result

	if current_module == GLOBALS.MODULE.SOFTWARE_INTEGRITY:
		current_file_type = FILE_TYPE.CODE
		path = CODE_PATH + str(current_difficulty) + "/"
		#path = result[randi() % result.size()]
		result = path + _dir_contents(path)[0]
	else:
		randomize()

		if (randf() > 0.5):
			current_file_type = FILE_TYPE.RECIPE
			path = RECIPE_PATH + str(current_difficulty) + "/"
			print (path)
			#path = result[randi() % result.size()]
			result = path + _dir_contents(path)[0]
		else:
			current_file_type = FILE_TYPE.EMAIL
			path = EMAIL_PATH + str(current_difficulty) + "/"
			print (path)
			#path = result[randi() % result.size()]
			result = path + _dir_contents(path)[0]

	_load_file(result)
	initiated = true

	yield(perform_opening_animation(), "completed")


func _unhandled_key_input(event: InputEventKey) -> void:
	if not initiated:
		return

	if event.is_pressed() and _is_letter(event.unicode):
		key_press_count += 10 # Have to play around with this value

		if current_file_type == FILE_TYPE.CODE:
			textBox.bbcode_text = "[code]" + message.substr(0, key_press_count) + "[/code]";
		else:
			textBox.bbcode_text = message.substr(0, key_press_count);


func _dir_contents(path) -> PoolStringArray:
	var items := PoolStringArray()

	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				items.append(file_name)
			file_name = dir.get_next()
	return items


func _load_file(file) -> void:
	var f = File.new()
	f.open(file, File.READ)

	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		line += "\n"
		message += line
	f.close()


func _is_letter(value : int) -> bool:
	if value in range(65, 90) or value in range(97, 122):
		return true
	return false


func _on_TextureButton_pressed() -> void:
	# Calculate the success rate
	var a : float = textBox.bbcode_text.length()
	var b : float = message.length() + (10 if current_file_type == FILE_TYPE.CODE else 0)
	var score = min(max(1, a) / b, 1)

	yield(perform_closing_animation(), "completed")
	# Submit the text
	emit_signal("finished", WINDOW_RESULT.SUBMIT,
	{
		"module"	: current_module,
		"value" 	: score >= 0.5,
	})
