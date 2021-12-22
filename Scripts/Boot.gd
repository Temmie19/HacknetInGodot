extends Node2D

onready var starting = get_node("Background/Starting")
onready var waiting = get_node("Background/Wait")
onready var background = get_node("OtherBackground")
onready var terminal = get_node("OtherBackground/RichTextLabel")
onready var music = get_node("Music")
onready var beep = get_node("Beeping")

var starter_up = true
var delay_finished = false
var wait_up = true

var starter_alpha = 0
var wait_alpha = 0

var gui_on = true
var auto_switch = true

func _ready():
	_load_file()

#func _process(delta):
#	pass

func _load_file():
	var f = File.new()
	var rng = RandomNumberGenerator.new()
	f.open("res://Assets/TextFiles/OSXBoot.txt", File.READ)
	var index = 1
	while not f.eof_reached():
		rng.randomize()
		yield(get_tree().create_timer(rng.randf_range(0, 1)), "timeout")
		var line = f.get_line()
		line += "\n"
		terminal.add_text(line)
		beep.play(0)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/MainScreen.tscn")

func _on_Fade_timeout():
	if starter_up == true:
		if starter_alpha >= 1:
			starter_up = false
		starter_alpha += 0.01
		starting.set_modulate(Color(1,1,1,starter_alpha))
	elif starter_up == false:
		if starter_alpha <= 0:
			starter_up = true
		starter_alpha -= 0.01
		starting.set_modulate(Color(1,1,1,starter_alpha))
	if delay_finished == true:
		if wait_up == true:
			if wait_alpha >= 1:
				wait_up = false
			wait_alpha += 0.01
			waiting.set_modulate(Color(1,1,1,wait_alpha))
		elif wait_up == false:
			if wait_alpha <= 0:
				wait_up = true
			wait_alpha -= 0.01
			waiting.set_modulate(Color(1,1,1,wait_alpha))

func _on_Delay_timeout():
	delay_finished = true

func _input(event):
	if event is InputEventKey and event.pressed:
		auto_switch = false
		if gui_on == true:
			gui_on = false
			_disable_gui()
		else:
			gui_on = true
			_enable_gui()

func _on_AutoSwitch_timeout():
	if auto_switch == true:
		if gui_on == true:
			gui_on = false
			_disable_gui()
		else:
			gui_on = true
			_enable_gui()

func _enable_gui():
	background.visible = true
	music.set_volume_db(-80)
	beep.set_volume_db(-20)

func _disable_gui():
	background.visible = false
	music.set_volume_db(0)
	beep.set_volume_db(-80)
