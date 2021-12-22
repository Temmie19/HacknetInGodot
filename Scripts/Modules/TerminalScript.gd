extends ColorRect

onready var history = get_node("Splitter/History")
onready var location = get_node("Splitter/CommandBar/Location")
onready var entry = get_node("Splitter/CommandBar/CommandEntry")

var line_count = 0
var total_lines = 0

var all_programs = {"SSHCrack.exe" : ["portcrusher", 
["SecureShellCrack", "SSH", 8]], "SQL_MemCorrupt.exe" : ["portcrusher", 
["SQLMemoryCorrupt", "SQL", 12.2]], "clear" : ["utility", "_clear_history"], 
"lines": ["utility", "_print_lines"]}

var available_programs = {"SSHCrack.exe" : ["portcrusher", 
["SecureShellCrack", "SSH", 8]], "SQL_MemCorrupt.exe" : ["portcrusher", 
["SQLMemoryCorrupt", "SQL", 12.2]], "clear" : ["utility", "_clear_history"], 
"lines": ["utility", "_print_lines"]}

func _ready():
	_calculate_terminal_size()
	#print(history.get_line_count())
	#print(history.get_visible_line_count())

func _calculate_terminal_size():
	var height = int(round(history.get_font("normal_font").get_height())) + 1
	var container_height = history.get_size().y - 10
	var lines = 0
	for i in range(container_height):
		if(height * lines <= history.get_size().y):
			lines += 1
		else:
			break
	#print("Font height: ", height, " Lines is: ", lines)
	total_lines = lines - 2
	for i in range(total_lines):
		history.newline()
	#print(history.get_visible_line_count())

#func _process(delta):
#	pass

func _on_CommandEntry_text_entered(new_text):
	var program_keys = available_programs.keys()
	var text = entry.get_text().split(" ", false)
	var command_valid = false
	if(text.size() > 0):
		if text[0] in available_programs:
			var program = available_programs[text[0]]
			if program[0] == "portcrusher":
				_run_portcrusher(program[1])
			elif program[0] == "utility":
				call(program[1])
		else:
			_invalid_command(text[0])

func _check_line_count():
	if(line_count < total_lines):
		history.remove_line(1)
		line_count += 1

func _clear_history():
	history.set_text("")
	entry.set_text("")
	line_count = 0
	for i in range(total_lines):
		history.newline()

func _print_lines():
	print("Line count: ", history.get_line_count())
	print("Content height: ", history.get_content_height())
	print("Container height: ", history.get_size().y)


func _add_to_terminal(text):
	history.add_text(text)
	_check_line_count()

func _invalid_command(text):
	_display_previous_command()
	_erase()
	_add_to_terminal(str("Invalid command ", text, " - Check syntax \n"))

func _run_portcrusher(portcrusher):
	var cracker = portcrusher[0]
	var port_name = portcrusher[1]
	var delay = portcrusher[2]
	_display_previous_command()
	_erase()
	yield(get_tree().create_timer(0.1), "timeout")
	_add_to_terminal(str(cracker + " running...\n"))
	yield(get_tree().create_timer(delay), "timeout")
	_add_to_terminal(str("-- " + cracker + " complete --\n"))

func _on_CommandEntry_gui_input(event):
	if(Input.is_action_pressed("ui_autocomplete") && entry.get_text() != ""):
		var text = entry.get_text()
		var program_keys = available_programs.keys()
		var valid_entries = []
		for key in range(program_keys.size()):
			var current = str(program_keys[key])
			if(current.findn(text) != -1):
				valid_entries.append(current)
		if(valid_entries.size() > 1):
			_display_previous_command()
			var list = "Available options: "
			for entries in valid_entries:
				list += entries + ", "
			list.erase(list.length() - 2, 2)
			list += "\n"
			_add_to_terminal(list)
		elif(valid_entries.size() == 1):
			var command = valid_entries[0]
			entry.set_text(command)
			entry.set_cursor_position(command.length())

func _display_previous_command():
	_add_to_terminal(str(location.get_text() + " " + entry.get_text() + "\n"))

func _erase():
	entry.set_text("")
