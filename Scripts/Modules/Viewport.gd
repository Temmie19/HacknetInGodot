extends ColorRect

onready var container = get_node("DaemonContainer")

func _ready():
	_connect_signals()
	pass # Replace wi

func _on_comp_connect(id, cname, ip):
	var computer = Status.active_computer
	var default = computer.default_daemon
	if default == "":
		var daemon = load("res://Scenes/Daemons/BaseDaemon.tscn").instance()
		for i in range(4):
			daemon.set_anchor(i, container.get_anchor(i))
		container.add_child(daemon)
	else:
		var daemon = load(DataCache.daemons[default].file).instance()
		for i in range(4):
			daemon.set_anchor(i, container.get_anchor(i))
		container.add_child(daemon)

func _on_comp_disconnect(ip):
	for c in container.get_children():
		c.queue_free()
		container.remove_child(c)

func _connect_signals():
	SignalBus.connect("connected", self, "_on_comp_connect")
	SignalBus.connect("disconnected", self, "_on_comp_disconnect")
	SignalBus.connect("changed_directory", self, "_on_directory_change")
