extends ColorRect

onready var container = get_node("DaemonContainer")

func _ready():
	
	pass # Replace wi

func _on_comp_connect(id, cname, ip):
	var computer = Status.active_computer
	if computer.default_daemon == "":
		
		pass
	pass

func _on_comp_disconnect(ip):
	for c in container.get_children():
		c.queue_free()
		container.remove_child(c)
