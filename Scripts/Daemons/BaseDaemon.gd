extends ColorRect

var button_base = preload("res://Scenes/Extras/Button.tscn")

onready var top_container = get_node ("VBoxContainer")
onready var button_container = get_node("VBoxContainer/HBoxContainer/ScrollContainer/Buttons")
onready var exit_button = get_node("VBoxContainer/Exit/disconnect")
onready var comp_name = get_node("VBoxContainer/Top/Labels/ComputerName")
onready var ip_label = get_node("VBoxContainer/Top/Labels/IP")
onready var disconnect_button = get_node("VBoxContainer/Exit/disconnect")
onready var admin_label = get_node("VBoxContainer/AdminTag")


func _ready():
	top_container.set_size(get_node(".").get_size())
	_add_buttons()
	_add_details()


func _add_buttons():
	var daemons = {}
	for available in Status.active_computer.available_daemons:
		daemons[available] = DataCache.daemons[available]
	var daemon_keys = daemons.keys()
	for key in daemon_keys:
		var daemon = daemons[key]
		if "button_text" in daemon:
			var button_instance = button_base.instance()
			button_instance.set_name(key)
			button_instance.set_custom_minimum_size(Vector2(500,50))
			button_instance.set("button_text", daemon["button_text"])
			button_instance.set("is_active", _set_active(daemon["available"]))
			button_container.add_child(button_instance)
	exit_button.get_node("ButtonContainer/Base/Label").set_text("Disconnect")
	exit_button.get_node("ButtonContainer/Base/Label").set("is_active", true)

func _set_active(input: String):
	var is_hacked = Status.active_computer.is_hacked
	if input == "always":
		return true
	elif not is_hacked && input == "without_hack":
		return true
	elif is_hacked && input == "needs_hack":
		return true

func _add_details():
	var comp = Status.active_computer
	comp_name.set_text("Connected to " + comp.display_name)
	ip_label.set_text("@" + comp.ip_address)
	if comp.is_hacked == true:
		admin_label.visible = true
	else:
		admin_label.visible = false
