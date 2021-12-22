extends VBoxContainer

onready var display = get_node("Display")
onready var timer = get_node("Timer")
onready var toggle = get_node("Count/Toggle")

var minimized = false

func _ready():
	pass

#func _process(delta):
#	pass

func _minimize():
	minimized = true
	toggle.set_text("+")
	var height = display.get_size()[1]
	var width = display.get_size()[0]
	while display.get_size()[1] > 0:
		timer.start()
		yield(timer, "timeout")
		height -= 5
		display.set_size(Vector2(width, height))
		if minimized == false:
			break

func _maximize():
	minimized = false
	toggle.set_text("-")
	var height = display.get_size()[1]
	var width = display.get_size()[0]
	timer.start()
	while display.get_size()[1] < 985:
		yield(timer, "timeout")
		height += 5
		display.set_size(Vector2(width, height))
		if minimized == true:
			break

func _on_Toggle_pressed():
	if minimized == false:
		_minimize()
	else:
		_maximize()
