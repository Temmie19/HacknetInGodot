extends Node

var daemons = {
	"base": {"file": "res://Scenes/Daemons/BaseDaemon.tscn"},
	"login": {"button_text": "Login", "file": "res://Scenes/Daemons/Login.tscn", "available": "without_hack", "type": "daemon"},
	"probe": {"button_text": "Probe", "file": "res://Scenes/Daemons/Probe.tscn", "available": "always", "type": "program"},
	"files": {"button_text": "View Filesystem", "file": "res://Scenes/Daemons/Filesystem.tscn", "available": "needs_hack", "type": "daemon"},
	"logs": {"button_text": "Logs", "file": "res://Scenes/Daemons/Filesystem.tscn", "available": "needs_hack", "type": "daemon"},
	"scan": {"button_text": "Scan", "file": "res://Scripts/Daemons/Scan.gs", "available": "needs_hack", "type": "program"},
}


func _ready():
	pass 
