extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var label = get_node(".")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("connected", self, "_on_comp_connect")
	pass # Replace with function body.


func _on_comp_connect(id, cname, ip):
	#if domain_name == "":
		label.set_text(str("Connected to: ", cname, " \nAt: ", ip, " "))
	#else:
	#	display.set_text(str(" ", display_name, " \n ", domain_name, " "))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
