extends ColorRect

var computer_node = preload("res://Scenes/Extras/ComputerNode.tscn")

onready var container = get_node("Container")

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _add_node(node_info:Dictionary):
	computer_node.instance()
	computer_node.name = node_info["id"]
	container.add_child(computer_node)
	var computer = get_node(str("Container/", node_info["name"]))
	var x = node_info["x"] / container.get_size().x
	var y = node_info["y"] / container.get_size().y
	computer.set_position(Vector2(x, y))
	computer.filesystem = node_info["filesystem"]
	computer.node_position = [x, y]
	computer.ports_available = node_info["ports_available"]
	computer.ports_to_hack = node_info["ports_to_hack"]
