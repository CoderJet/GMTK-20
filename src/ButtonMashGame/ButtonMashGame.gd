extends Node2D

enum FILE_TYPE {
	CODE = 0,
	RECIPE,
	EMAIL,
}

signal success
signal failure

onready var textBox = get_node("CanvasLayer/TextArea")

const CODE_PATH = "res://src/ButtonMashGame/Files/Code/"
const RECIPE_PATH = "res://src/ButtonMashGame/Files/Recipes/"
const EMAIL_PATH = "res://src/ButtonMashGame/Files/Emails/"

var message := String()
var key_press_count : int = 0
var current_file_type = FILE_TYPE.CODE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_load_file(temp)
	initiate_minigame(FILE_TYPE.CODE)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed():
		key_press_count += 3 # Have to play around with this value

		if current_file_type == FILE_TYPE.CODE:
			textBox.bbcode_text = "[code]" + message.substr(0, key_press_count) + "[/code]";
		else:
			textBox.bbcode_text = message.substr(0, key_press_count);


func initiate_minigame(value : int) -> void:
	current_file_type = value
	var path
	randomize()

	if current_file_type == FILE_TYPE.CODE:
		var result = _dir_contents(CODE_PATH)
		path = result[randi() % result.size()]
		print(CODE_PATH + path)
		_load_file(CODE_PATH + path)
	elif current_file_type == FILE_TYPE.RECIPE:
		var result = _dir_contents(RECIPE_PATH)
		path = result[randi() % result.size()]
		_load_file(RECIPE_PATH + path)
	elif current_file_type == FILE_TYPE.EMAIL:
		var result = _dir_contents(EMAIL_PATH)
		path = result[randi() % result.size()]
		_load_file(EMAIL_PATH + path)

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


func _on_TextureButton_pressed() -> void:
	# Calculate the success rate
	var a : float = textBox.bbcode_text.length()
	var b : float = message.length() + (10 if current_file_type == FILE_TYPE.CODE else 0)
	var score = min(max(1, a) / b, 1)
	print(score)

	## Check against game's pass criteria
	if score >= 0.5:
		emit_signal("success", score)
	else:
		emit_signal("failure", score)
