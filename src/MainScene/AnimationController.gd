extends Control

signal animation_ended

onready var welcome = $Welcome/WelcomeImage
onready var header = $Header
onready var footer = $Footer
onready var button = $"Footer/WHOOPS Footer/WHOOPS Button"
onready var world = $Worlds
onready var shields = $Shields
onready var modules = $Modules

enum STATE {
	WELCOME_IMAGE = 0,
	FOOTER,
	EMERGENCY,
	WORLD,
	SHIELDS,
	MODULES,
	HEADER
}

export(StreamTexture) var abort
export(StreamTexture) var abort_down

var state = STATE.WELCOME_IMAGE
var current_time = 0
var cooldown_time = 1

var flash_cooldown = 0.3
var flash_time = flash_cooldown
var flash_state = true
var flash_count = 0

var shield_cooldown = 0.4
var shield_time = shield_cooldown
var shield_count = 1

var animate = true

var module_count = 1
var module_fade_in = 0.5

export var header_fill_time = 4
var header_time = 0
var time_milliseconds_full = 5 * 60

var module_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", self, "_begin_game_animation")
	module_map[1] = $Modules/ModulesLeft/Module
	module_map[2] = $Modules/ModulesLeft/Module2
	module_map[3] = $Modules/ModulesLeft/Module3
	module_map[4] = $Modules/ModulesLeft/Module4
	pass # Replace with function body.

func _begin_game_animation():
	state = STATE.EMERGENCY

func _process(delta):

	if not animate:
		return

	if current_time < cooldown_time:
		current_time += delta
		return
	else:
		cooldown_time = current_time
	
	match state:
		STATE.WELCOME_IMAGE:
			#welcome.visible = true
			welcome.modulate.a += delta
			if welcome.modulate.a >= 1:
				cooldown_time += 0.1
				state += 1
			pass
		STATE.FOOTER:
			footer._start_animation()
			pass
		STATE.EMERGENCY:
			#button.visible = false
			button.texture_normal = abort
			button.texture_pressed = abort_down
			
			welcome.modulate.a -= delta
			if welcome.modulate.a <= 0:
				welcome.modulate.a = 0
				
				if flash_count < 6:
					if flash_time <= 0:
						world.get_node("EmergencyWarning").visible = flash_state
						flash_state = !flash_state
						flash_time += flash_cooldown
						flash_count += 1
					else:
						flash_time -= delta
				else:
					cooldown_time += 0.5
					state += 1
			pass
		STATE.WORLD:
			world.get_node("WorldNormal").modulate.a += delta/2
			if world.get_node("WorldNormal").modulate.a > 1:
				world.get_node("WorldNormal").modulate.a = 1
				
				state += 1
				cooldown_time += 0.2
			
			pass
		STATE.SHIELDS:
			if shield_count > 3:
				state += 1
				cooldown_time = 0.2
			else:
				if shield_time <= 0:
					shield_time = shield_cooldown
					if shield_count == 1:
						shields.get_node("Shield1").visible = true
					elif shield_count == 2:
						shields.get_node("Shield2").visible = true
					elif shield_count == 3:
						shields.get_node("Shield3").visible = true
					
					shield_count += 1
				else:
					shield_time -= delta
			
			pass
		STATE.MODULES:
			if module_count > 4:
				state += 1
				cooldown_time = 0.3
			else:
				module_map[module_count].modulate.a += delta * 1/module_fade_in
				if module_map[module_count].modulate.a >= 1:
					module_map[module_count].modulate.a = 1
					module_count += 1
			
			pass
		STATE.HEADER:
			header.modulate.a += delta
			header.modulate.a += delta
			if header.modulate.a >= 1:
				header.modulate.a = 1
				
				header_time += (delta * 1/header_fill_time * time_milliseconds_full)
				if header_time > 300:
					header_time = 300
				
				var mins = int(header_time / 60)
				var secs = int(header_time) % 60
				var mSecs = 0
			
				var a = stepify(float(header_time), 0.001)
				var b = String(a).split('.')
			
				if b.size() == 2:
					mSecs = int(b[1])
				
				header.get_node("RemainingTime").text = "%02d:%02d:%03d" % [mins, secs, mSecs]
				
				header.get_node("Header_full").value += delta * 1/header_fill_time * 100
				if header.get_node("Header_full").value >= 100:
					emit_signal("animation_ended")
					animate = false
			
			pass	
	
	pass
