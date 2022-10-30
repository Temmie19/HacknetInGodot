extends Node

var daemons = [
	{"name": "base", "file": "res://Scenes/Daemons/BaseDaemon.tscn"},
	{"name": "login", "button_text": "Login", "file": "res://Scenes/Daemons/Login.tscn", "available": "without_hack"},
	{"name": "probe", "button_text": "Probe", "file": "res://Scenes/Daemons/Probe.tscn", "available": "always"},
	{"name": "files", "button_text": "View Filesystem", "file": "res://Scenes/Daemons/Filesystem.tscn", "available": "needs_hack"},
	{"name": "logs", "button_text": "Logs", "file": "res://Scenes/Daemons/Logs.gs", "available": "needs_hack"},
	{"name": "scan", "button_text": "Scan", "file": "res://Scripts/Daemons/Scan.gs", "available": "needs_hack"},
]


func _ready():
	pass 
