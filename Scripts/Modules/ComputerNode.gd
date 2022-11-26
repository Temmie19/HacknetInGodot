extends Node2D

var is_connected = false
var is_hacked = false
var is_recently_scanned = false
var is_asset_server = false
var is_hub_server = false
var is_visible = true
var rotate = false

var filesystem : Dictionary = {"home":{}, "log":{}, "bin":{}, 
	"sys":{"xserver.sys":"#BASE_THEME#", "os-config.sys":"#BINARY#",
		"bootcfg.dll":"#BINARY#", "netcfgx.dll":"#BINARY#"}}

var ports_available : Array = []
var ports_to_hack : int = 0
var has_proxy : bool = false
var proxy_length : int = 1
var has_firewall : bool = false
var firewall_step_length : int = 1
var firewall_solution : String = ""
var trace_time : int = -1
var available_daemons : Array = []
var daemon_data : Dictionary = {}
var default_daemon : String = ""

var node_difficulty : int = -1

var ip_address : String = "192.168.0.2"
var domain_name : String = ""
var display_name : String = "Player's Computer"

var node_position : Array = []

onready var node = get_node(".")
onready var anim = get_node("AnimationPlayer")
onready var display = get_node("Display")
onready var background = get_node("Display/Background")

onready var display_loc = display.get_canvas_item()

func _ready():
	anim.play("Rotate")
	VisualServer.canvas_item_set_z_index(display_loc, 100)
	if(name == "playerComp"):
		#If this is the player's computer, make a quick reference to it in Status
		Status.player_computer = get_node(".")
		#print("Player computer: ", Status.player_computer)
	SignalBus.connect("nodemap_resized", self, "_reallign_node")

func _set_display_info():
	if domain_name == "":
		display.set_text(str(" ", display_name, " \n ", ip_address, " "))
	else:
		display.set_text(str(" ", display_name, " \n ", domain_name, " "))

func _process(delta):
	_check_visibility()

func _check_visibility():
	if is_visible:
		node.visible = true
	else:
		node.visible = false

func _on_mouse_entered():
	display.visible = true


func _on_mouse_exited():
	display.visible = false

func _on_node_click(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed() == true \
		and event.doubleclick == true:
			print("Double click")
		elif event.get_button_index() == 1 and event.is_pressed() == true:
			SignalBus.emit_signal("disconnected", ip_address)
			SignalBus.emit_signal("connected", self.name, display_name, ip_address)
			print("Click")

func _reallign_node(containerXY: Vector2):
	#This code, while seemingly simple, took a long time for me to write. In theory
	#this shouldn't be that hard to do. Get the size of the node map, and adjust
	#the position of the nodes so they'll always been in an equivalent space on
	#the map even when the module is resized. However, actually calculating this
	#took a long time to figure out, because certain calculations actually worked
	#but only on SOME of the nodes. Not all of them. And THAT is why this was
	#as frustrating to make as it was. 
	if node_position.size() == 2:
		var x = 0
		var y = 0
		if not round(containerXY.x) == 0:
			x = int(node_position[0] / float(100) * round(containerXY.x))
		if not round(containerXY.y) == 0:
			y = int(node_position[1] / float(100) * round(containerXY.y))
		get_node(".").set_position(Vector2(x, y))
