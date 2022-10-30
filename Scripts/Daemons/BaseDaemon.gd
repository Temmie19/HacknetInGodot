extends ColorRect

var button_base = preload("res://Scenes/Extras/Button.tscn")

onready var button_container = get_node("VBoxContainer/HBoxContainer/ScrollContainer/Buttons")
onready var exit_button = get_node("VBoxContainer/Exit/disconnect")


func _ready():
	_add_buttons()


func _add_buttons():
	var daemons = DataCache.daemons
	for daemon in daemons:
		if "button_text" in daemon:
			var button_instance = button_base.instance()
			button_instance.set_name(daemon.name)
			button_instance.set_custom_minimum_size(Vector2(500,50))
			button_instance.set("button_text", daemon["button_text"])
			button_instance.set("is_active", _set_active(daemon["available"]))
			button_container.add_child(button_instance)
	exit_button.get_node("ButtonContainer/Base/Label").set_text("Disconnect")
	exit_button.get_node("ButtonContainer/Base/Label").set("is_active", true)

func _set_active(input: String):
	var is_hacked = false#Status.active_computer.is_hacked
	if input == "always":
		return true
	elif not is_hacked && input == "without_hack":
		return true
	elif is_hacked && input == "needs_hack":
		return true
