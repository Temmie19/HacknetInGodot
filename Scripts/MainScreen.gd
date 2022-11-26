extends Node2D

onready var Frames = get_node("VSplitContainer/MenuBar/FPS")
onready var interfaces = get_node("VSplitContainer/Interfaces")

onready var ram = get_node("VSplitContainer/Interfaces/MainSplitter/SecondarySplitter/RAM")
onready var display = get_node("VSplitContainer/Interfaces/MainSplitter/SecondarySplitter/HorzContainer/Viewport")
onready var nodemap = get_node("VSplitContainer/Interfaces/MainSplitter/SecondarySplitter/HorzContainer/NodeMap")
onready var terminal = get_node("VSplitContainer/Interfaces/MainSplitter/Terminal")
onready var history : RichTextLabel = terminal.get_node("Splitter/History")

onready var music = get_node("Music")
onready var sfx1 = get_node("SoundEffects1")
onready var sfx2 = get_node("SoundEffects2")

func _ready():
	print(OS.get_window_size())
	OS.set_window_size(Vector2(1366, 720))
	_startup_sequence()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	print(rng.randi(), " ", rng.randi(), " ", rng.randi(), " ", rng.randi())

func _process(delta):
	Frames.set_text(str(Engine.get_frames_per_second()))

func _startup_sequence():
	music.stream = load("res://Assets/Sounds/Startup.ogg")
	music.play(0)
	for _i in range(4):
		interfaces.visible = true
		yield(get_tree().create_timer(0.05), "timeout")
		interfaces.visible = false
		yield(get_tree().create_timer(0.05), "timeout")
	interfaces.visible = true
	yield(get_tree().create_timer(1), "timeout")
	_boot_flash(ram)
	yield(get_tree().create_timer(0.6), "timeout")
	_boot_flash(display)
	yield(get_tree().create_timer(0.3), "timeout")
	_boot_flash(nodemap)
	yield(get_tree().create_timer(0.6), "timeout")
	_boot_flash(terminal)
	yield(get_tree().create_timer(0.8), "timeout")

func _boot_flash(node):
	for _i in range(4):
		node.set_modulate(Color(1,1,1,1))
		#node.visible = true
		yield(get_tree().create_timer(0.05), "timeout")
		node.set_modulate(Color(1,1,1,0))
		#node.visible = false
		yield(get_tree().create_timer(0.05), "timeout")
	node.set_modulate(Color(1,1,1,1))
	#node.visible = true

func _play_music(song, loop=true):
	pass

func _on_Node2D_draw():
	get_node(".").visible = false
	get_node(".").visible = true
	pass

func _on_Background_resized():
	update()
