extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var label = get_node(".")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("connected", self, "_on_comp_connect")
	SignalBus.connect("disconnected", self, "_on_comp_disconnect")


func _on_comp_connect(id, cname, ip):
	label.set_text(str("Connected to: ", cname, " \nAt: ", ip, " "))

func _on_comp_disconnect(ip):
	label.set_text(str("Connected to: \nAt:  "))
