extends Node2D

var is_connected = false
var is_hacked = false
var is_recently_scanned = false
var is_asset_server = false
var is_hub_server = false
var is_visible = true
var rotate = false

var filesystem : Dictionary = {"home/":{}, "log/":{}, "bin/":{}, 
	"sys/":{"xserver.sys":"#BASE_THEME#", "os-config.sys":"#BINARY#",
		"bootcfg.dll":"#BINARY#", "netcfgx.dll":"#BINARY#"}}

var ports_available : Array = []
var ports_to_hack : int = 0
var has_proxy : bool = false
var proxy_length : int = 1
var has_firewall : bool = false
var firewall_step_length : int = 1
var firewall_solution : String = ""
var trace_time : int = -1

var node_difficulty : int = -1

var ip_address : String = "192.168.0.2"
var display_name : String = "Player's Computer"

var node_position : Array = [0, 0]

onready var node = get_node(".")
onready var anim = get_node("AnimationPlayer")
onready var display = get_node("Display")
onready var background = get_node("Display/Background")

func _ready():
	anim.play("Rotate")
	display.set_text(str(" ", display_name, " \n ", ip_address, " "))

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
