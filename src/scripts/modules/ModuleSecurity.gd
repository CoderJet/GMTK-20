extends ModuleWindowCore


export (String, MULTILINE) var KeywordList

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

var word := ""

onready var window = get_node("Window")
onready var captcha_text = get_node("Window/CaptchaText")
onready var player_input = get_node("Window/PlayerInputBorder/PlayerInput")


func _ready():
	window.window_title = "Security Checks"
	window.flavour_text = "Enter in the below captcha in order to reconfigure security protocols."

	randomize()
	var items = KeywordList.split('\n')

	word = items[randi() % items.size()].strip_edges()
	randomize()
	var bbcode_value = BB_CODES[randi() % BB_CODES.size()] % word

	captcha_text.bbcode_text = "[center]\n\n%s[/center]" % bbcode_value
	yield(perform_opening_animation(), "completed")


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed:
		if event.scancode ==  KEY_BACKSPACE:
			player_input.text = player_input.text.substr(0, player_input.text.length() - 1)
		else:
			if player_input.text.length() < word.length():
				player_input.text += PoolByteArray([event.unicode]).get_string_from_utf8()


func _on_ButtonAuthenticate_pressed() -> void:
	yield(perform_closing_animation(), "completed")
	# Submit the text
	emit_signal("finished", WINDOW_RESULT.SUBMIT,
	{
		"module"	: current_module,
		"value" 	: player_input.text.to_lower() == word.to_lower(),
	})
