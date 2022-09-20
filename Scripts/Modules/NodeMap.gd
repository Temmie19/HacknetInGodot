extends ColorRect

var computer_node = preload("res://Scenes/Extras/ComputerNode.tscn")
var generate = preload("res://Scripts/Modules/ComputerGeneration.gd").new()
var ip_display = preload("res://Scenes/Extras/IPDisplay.tscn")

var rng = RandomNumberGenerator.new()

var nodes_generated : bool = false

onready var container = get_node("Container")
onready var nlight = get_node("LightNode")
onready var llight = get_node("LightLabel")
#onready var label_container = get_node("LabelContainer")

func _ready():
	_run_node_checks({})
	#print(JSON.parse(_read_file("res://Computers/test.json")).result)
	_add_node(JSON.parse(_read_file("res://Computers/test.json")).result)
	#print("Light size: ", nlight.get_size())
	pass # Replace with function body.

#func _process(delta):
#	pass

func _add_node(computers:Array):
	var csize = container.get_size()
	#Read the initial array with all the computers inside of it, then setup up
	#each computer for generation
	for i in computers:
		var node_info = i["Computer"]
		var new_computer = computer_node.instance()
		#ip_display.instance()
		var id = node_info["id"]
		var cname = node_info["display_name"]
		new_computer.set_name(id)
		#ip_display.name = id
		container.add_child(new_computer)
		var computer = get_node(str("Container/", id))
		#var ip_label = get_node(str("LabelContainer/", cname))
		node_info = _run_node_checks(node_info)
		#Set variable for positional coordinates
		var x = 0
		var y = 0
		#If it has a position already in the file, use that, otherwise pick
		#something random instead
		#This code was actually completely rewritten for the module adjustment code
		#and let me tell you, this took like 3 days to figure out why the nodes 
		#where ust getting stuck in the corner when they really should've been in
		#their correct spots. Probably one of the most annoying things to figure
		#out to date. Perhaps even trumping the terminal code in terms of frustration.
		if "node_position" in node_info and node_info["node_position"].size() == 2:
			x = round(int(node_info["node_position"][0]) % 100)
			y = round(int(node_info["node_position"][1]) % 100)
			computer.node_position = [x,y]
		else:
			x = rng.randi_range(0, 100)
			y = rng.randi_range(0, 100)
			computer.node_position = [x,y]
			node_info["node_position"] = [x,y]
			x = int(round(x / float(100) * csize.x))
			y = int(round(y / float(100) * csize.y))
		#Set the node position
		computer._reallign_node(csize)
		#ip_label.set_position(Vector2(x, y))
		var node_keys = node_info.keys()
		for j in range(node_keys.size()):
			computer.set(node_keys[j], node_info[node_keys[j]])
		computer._set_display_info()
		nodes_generated = true

func _run_node_checks(node_info:Dictionary):
	var port_count = 0
	var minimum_ports_required = 0 
	var proxy_firewall = 0
	var length = 0
	var trace_time = 0
	#Check if content needs to be auto generated, and if so set the variables
	#to the correct difficulty
	if "node_difficulty" in node_info and not node_info["node_difficulty"] == -1:
		if node_info["node_difficulty"] == 0:
			port_count = rng.randi_range(1,3)
			minimum_ports_required = rng.randi_range(1, port_count)
		elif node_info["node_difficulty"] == 1:
			port_count = rng.randi_range(2,4)
			minimum_ports_required = rng.randi_range(2, port_count)
			proxy_firewall = rng.randi_range(1,2)
			length = rng.randi_range(1,2)
			trace_time = rng.randi_range(150, 180)
		elif node_info["node_difficulty"] == 2:
			port_count = rng.randi_range(3,5)
			minimum_ports_required = rng.randi_range(3, port_count)
			proxy_firewall = rng.randi_range(1,3)
			length = rng.randi_range(1,3)
			trace_time = rng.randi_range(120, 150)
		elif node_info["node_difficulty"] == 3:
			port_count = rng.randi_range(4,6)
			minimum_ports_required = rng.randi_range(3, port_count)
			proxy_firewall = 3
			length = rng.randi_range(2,5)
			trace_time = rng.randi_range(100, 130)
		elif node_info["node_difficulty"] == 4:
			port_count = rng.randi_range(5,8)
			minimum_ports_required = rng.randi_range(4, port_count)
			proxy_firewall = 3
			length = rng.randi_range(3,6)
			trace_time = rng.randi_range(90, 120)
			#Man having to hack a computer with 8 ports, 90 second trace time,
			#a proxy that requires 6 shells to crack it in 30 seconds, 14 character 
			#long firewall with 8.5 seconds to parse each section just sounds
			#like a bad time. Like holy smokes that's hell. Thankfully that's
			#probably a pretty unlikely outcome to have all of those happen
		node_info = generate._add_generated_difficulty(port_count, minimum_ports_required, 
			proxy_firewall, length, trace_time, node_info)
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
		rng.randomize()
		#If it's empty, randomly assign it a set of 4 numbers between 0 and 255
		#seperated each by periods, just like an actual IP address
		node_info["ip_address"] = str(rng.randi_range(0, 255),".",rng.randi_range(0, 255),".",
			rng.randi_range(0, 255),".",rng.randi_range(0, 255))
		print(node_info["ip_address"])
	return node_info

func _read_file(path:String):
	#Reads a file at the given path and returns the content. Pretty intense stuff
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func _ip_label_switch(comp_name, mode):
	if mode == "entered":
		get_node(str("LabelContainer/", comp_name)).visible = true
	else:
		get_node(str("LabelContainer/", comp_name)).visible = false
	pass

func _lights_off():
	nlight.visible = false
	llight.visible = false

func _lights_on():
	nlight.visible = true
	llight.visible = true

func _on_Container_resized():
	#So this code actually took me a whole long time to figure out because of some odd quirks
	#when it comes to Godot. Basically is what this does, is try to reallign the lights that
	#allow for nodes and labels to be visible when the modules get readjusted. Surprisingly
	#difficult to set up, but definitely important for polish.
	if get_node("Container").rect_size != null:
		var csize = get_node("Container").get_size()
		var nsize = get_node(".").get_size()
		var cpos = get_node("Container").get_position()
		SignalBus.emit_signal("nodemap_resized", csize)
		if round(csize.x) > 0 and round(csize.y) > 0:
			#This repositions and resizes the lights that allow the nodes to be
			#clipped when they exit the barriers of the node map
			get_node("LightNode").set("position", Vector2(cpos.x + (csize.x / 2), cpos.y + (csize.y / 2)))
			get_node("LightNode").set("scale", Vector2(csize.x, csize.y))
			get_node("LightLabel").set("position", Vector2(nsize.x / 2, nsize.y / 2))
			get_node("LightLabel").set("scale", Vector2(nsize.x, nsize.y))
