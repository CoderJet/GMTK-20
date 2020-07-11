extends Node2D

const BB_CODES = [
	## Out of the box
	'[wave amp=50 freq=2]%s[/wave]',
	'[tornado radius=5 freq=2]%s[/tornado]',
	'[shake rate=5 level=10]%s[/shake]',
	'[fade start=4 length=14]%s[/fade]',
	'[rainbow freq=0.2 sat=10 val=20]%s[/rainbow]',
	## Custom
	'[ghost freq=5.0 span=10.0]%s[/ghost]',
	'[pulse color=#00FFAA height=0.0 freq=2.0]%s[/pulse]',
	'[matrix clean=2.0 dirty=1.0 span=50]%s[/matrix]',
]
signal success
signal failure

export (String, MULTILINE) var KeywordList

var word := ""

onready var player_input = get_node("CanvasLayer/PlayerInput")

func _ready():
	randomize()
	var items = KeywordList.split('\n')

	word = items[randi() % items.size()]
	randomize()
	var bbcode_value = BB_CODES[randi() % BB_CODES.size()] % word

	$CanvasLayer/CaptchaText.bbcode_text = "[center]\n\n%s[/center]" % bbcode_value


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed:
		if event.scancode ==  KEY_ENTER:
			# Submit the text
			if player_input.text.to_lower() == word.to_lower():
				emit_signal("success", 1)
			else:
				emit_signal("failure", 1)
		elif event.scancode ==  KEY_BACKSPACE:
			player_input.text = player_input.text.substr(0, player_input.text.length() - 1)
		else:
			if player_input.text.length() < word.length():
				player_input.text += PoolByteArray([event.unicode]).get_string_from_utf8()
