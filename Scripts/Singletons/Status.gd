extends Node

var is_connected : bool = false

var active_computer
var player_computer
var active_ip

var current_directory = "/"

onready var base_scene = get_tree().get_root().get_children()[-1]
onready var node_map = base_scene.get_node("VSplitContainer/Interfaces/MainSplitter/SecondarySplitter/HorzContainer/NodeMap")

func _ready():
	SignalBus.connect("connected", self, "_on_comp_connect")
	SignalBus.connect("changed_directory", self, "_on_directory_change")
	SignalBus.connect("disconnected", self, "_on_comp_disconnect")
	#player_computer = node_map.get_node("Container/playerComp")

func _on_comp_connect(id, cname, ip):
	active_computer = node_map.get_node(str("Container/", id))
	current_directory = "/"
	active_ip = ip
	print(active_computer)

func _on_comp_disconnect(ip):
	active_computer = null
	active_ip = null
	current_directory = "/"

func _on_directory_change(location):
	current_directory = location

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
