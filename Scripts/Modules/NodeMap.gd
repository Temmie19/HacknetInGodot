extends ColorRect

var computer_node = preload("res://Scenes/Extras/ComputerNode.tscn")
var generate = preload("res://Scripts/Modules/ComputerGeneration.gd").new()

onready var container = get_node("Container")

func _ready():
	_run_node_checks({})
	pass # Replace with function body.

#func _process(delta):
#	pass

func _add_node(computers:Array):
	for i in computers:
		var node_info = computers[i]["Computer"]
		computer_node.instance()
		computer_node.name = node_info["id"]
		container.add_child(computer_node)
		var computer = get_node(str("Container/", node_info["name"]))
		node_info = _run_node_checks(node_info)
		var x = node_info["x"] / container.get_size().x
		var y = node_info["y"] / container.get_size().y
		computer.set_position(Vector2(x, y))
		var node_keys = node_info.keys()
		for j in range(node_keys.size()):
			computer.set(node_keys[j], node_info[node_keys[j]])

func _run_node_checks(node_info:Dictionary):
	#Check if content needs to be auto generated
	if "node_difficulty" in node_info:
		if node_info["node_difficulty"] == 0:
			pass
		elif node_info["node_difficulty"] == 1:
			pass
		elif node_info["node_difficulty"] == 2:
			pass
		elif node_info["node_difficulty"] == 3:
			pass
		elif node_info["node_difficulty"] == 4:
			pass
	#Add any missing data
	node_info = _add_missing_data(node_info)
	#Return node_info after all modifications and checks complete
	return node_info

func _add_missing_data(node_info:Dictionary):
	var default_comp : Dictionary = JSON.parse(
		_read_file("res://Computers/default_computer.json")).result["Computer"]
	#Check each value in the default computer in the given computer
	for i in range(default_comp.keys().size()):
		var current_key = default_comp.keys()[i]
		#Add value if not found in the given computer
		if not current_key in node_info:
			node_info[current_key] = default_comp[current_key]
	#After that's done, check if the IP address is empty
	if node_info["ip_address"] == "":
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		#If it's empty, randomly assign it a set of 4 numbers between 0 and 255
		#seperated each by periods, just like an actual IP address
		node_info["ip_address"] = str(rng.randi_range(0, 255),".",rng.randi_range(0, 255),".",
			rng.randi_range(0, 255),".",rng.randi_range(0, 255))
		print(node_info["ip_address"])
	return node_info

func _read_file(path:String):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
