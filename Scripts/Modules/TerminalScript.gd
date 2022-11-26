extends ColorRect

onready var history = get_node("Splitter/History")
onready var location = get_node("Splitter/CommandBar/Location")
onready var entry = get_node("Splitter/CommandBar/CommandEntry")

var config = ConfigFile.new()

const DefaultPrograms = preload("res://Scripts/Modules/DefaultPrograms.gd")
onready var terminal_programs = DefaultPrograms.new()

var line_count = 0
var total_lines = 0

var all_programs = {}
var program_binary = {}

var available_programs = {"SSHCrack.exe" : ["portcrusher", 
["SecureShellCrack", "SSH", 8]], "SQL_MemCorrupt.exe" : ["portcrusher", 
["SQLMemoryCorrupt", "SQL", 12.2]], "clear" : ["terminal_program", "_clear_history"], 
"connect": ["terminal_program", "_connect"], "ls" : ["terminal_program", "_ls"],
"disconnect": ["terminal_program", "_disconnect"], "dc": ["terminal_program", 
"_disconnect"]}
#"SSHCrack.exe" : ["program", "SSH_CRACK", program_binary["SSH_CRACK"]]

func _ready():
	_calculate_terminal_size()
	_read_main_programs()
	_connect_signals()
	terminal_programs.call("_clear_history")
	#print(history.get_line_count())
	#print(history.get_visible_line_count())

func _calculate_terminal_size():
	var height = int(round(history.get_font("normal_font").get_height())) + 1
	var container_height = history.get_size().y - 10
	var lines = 0
	#This took way too long long to figure out because Godot just doesn't want
	#to handle this in any proper way. Basically, what I had to do was calculate
	#the height of the font plus an extra pixel to compensate for spacing, then
	#I had to calculate the size of the actual Rich Text Label that holds
	#all the terminal history, then divide that height by the amount of lines of
	#text, so that I could finally achieve the goal of having text that started
	#at the bottom, like a real command line
	for _i in range(container_height):
		if(height * lines <= history.get_size().y):
			lines += 1
		else:
			break
	print("Font height: ", height, " Lines is: ", lines)
	total_lines = lines - 2
	for _i in range(total_lines):
		history.newline()
	print(history.get_visible_line_count())

#func _process(delta):
#	pass

func _on_CommandEntry_text_entered(new_text):
	var program_keys = available_programs.keys()
	var text : Array = entry.get_text().split(" ", false)
	var command_valid = false
	#Basically we want to check if there's actually text in the entry field
	#first, and then if there is see if it's a valid program
	if(text.size() > 0):
		if text[0] in available_programs:
			var program = available_programs[text[0]]
			#After it's validated as a real program, next we check the type of
			#program so that the correct function can be called
			if program[0] == "portcrusher":
				_run_portcrusher(program[1])
			elif program[0] == "terminal_program":
				text.pop_front()
				terminal_programs.call(program[1], text)
		else:
			_invalid_command(text[0])

func _check_line_count():
	#This is basically so we don't have that giant blank chunk at the top
	#so it seems more like an actual command line. Pretty neat right?
	if(line_count < total_lines):
		history.remove_line(1)
		line_count += 1

func _print_lines():
	print("Line count: ", history.get_line_count())
	print("Content height: ", history.get_content_height())
	print("Container height: ", history.get_size().y)


func _add_to_terminal(text):
	#Adds the needed text to the terminal, and then checks if there are any extra
	#blank lines at the top to delete
	history.add_text(text)
	_check_line_count()

func _invalid_command(text):
	#So if we manage to get an invalid command put in, we need to handle that
	#so it will function like a real command line
	_display_previous_command()
	_erase()
	_add_to_terminal(str("Invalid command ", text, " - Check syntax \n"))

func _run_portcrusher(portcrusher):
	var cracker = portcrusher[0]
	var port_name = portcrusher[1]
	var delay = portcrusher[2]
	_display_previous_command()
	_erase()
	#Eventually this will cause a flag to occur on a computer node that will
	#crack the port required to enter
	yield(get_tree().create_timer(0.1), "timeout")
	_add_to_terminal(str(cracker + " running...\n"))
	yield(get_tree().create_timer(delay), "timeout")
	_add_to_terminal(str("-- " + cracker + " complete --\n"))

func _on_CommandEntry_gui_input(event):
	#If "ui_autocomplete", or its lesser known name "tab", is pressed while the
	#entry field isn't empty, it'll try to autocomplete with the available options
	if(Input.is_action_pressed("ui_autocomplete") && entry.get_text() != ""):
		var text = entry.get_text()
		var program_keys = available_programs.keys()
		var valid_entries = []
		#Search each program name for the string in the entry field, and if it's
		#found, add it to the potentional programs
		for key in range(program_keys.size()):
			var current = str(program_keys[key])
			if(current.findn(text) != -1):
				valid_entries.append(current)
		if(valid_entries.size() > 1):
			#If more than one command is possible out of the given entry, list
			#them in the terminal and make sure the entry field doesn't get cleared
			_display_previous_command()
			var list = "Available options: "
			for entries in valid_entries:
				list += entries + ", "
			list.erase(list.length() - 2, 2)
			list += "\n"
			_add_to_terminal(list)
		elif(valid_entries.size() == 1):
			#If only one option is available, just auto complete and move the
			#cursor to the end
			var command = valid_entries[0]
			entry.set_text(command)
			entry.set_cursor_position(command.length())

func _display_previous_command():
	#Basically it takes the text in entry field and in the location, and then
	#puts it in the terminal like a real command line. Going for realism here!!
	_add_to_terminal(str(location.get_text() + " " + entry.get_text() + "\n"))

func _erase():
	#Erases
	entry.set_text("")

func _read_main_programs():
	#This loads all the base programs provided by the game, starting with the
	#port crushers first
	var default_programs = config.load("res://Scripts/Configs/default_portcrushers.ini")
	for program in config.get_sections():
		all_programs[program] = {}
		program_binary[program] = _generate_binary(program)
		for attribute in config.get_section_keys(program):
			all_programs[program][attribute] = config.get_value(program, attribute)
		all_programs[program]["portcrusher"] = true
	#print(program_binary)

func _generate_binary(program_name):
	var rng = RandomNumberGenerator.new()
	var new_seed = 0
	for i in range(len(program_name)):
		new_seed += ord(program_name[i])
	rng.seed = new_seed
	var binary = ""
	for i in range(150):
		binary += str(rng.randi_range(0,1))
	return binary

func _on_comp_connect(id, cname, ip):
	#So whenever we connect to a computer we have to print a "connecting to",
	#line, a "sucessfully connected to" line, and then we also have to make sure
	#that the terminal location is updated to the correct IP and directory
	_add_to_terminal(str("Connecting to: ", ip, "...\n"))
	yield(get_tree().create_timer(0.1), "timeout")
	_add_to_terminal(str("Connected to ", cname, "@", ip, "\n"))
	location.set_text(str(Status.active_ip, Status.current_directory, " >"))

func _on_comp_disconnect(ip):
	_add_to_terminal(str("Disconnected from ", ip, "\n"))
	location.set_text("/ >")

func _on_directory_change(location):
	#Update the location on the terminal whenever we have a directory change
	location.set_text(str(Status.active_ip, Status.current_directory, " >"))

func _connect_signals():
	SignalBus.connect("connected", self, "_on_comp_connect")
	SignalBus.connect("disconnected", self, "_on_comp_disconnect")
	SignalBus.connect("changed_directory", self, "_on_directory_change")

func _on_Terminal_resized():
	var hsize = get_node("Splitter/History").get_size()
	if round(hsize.x) > 0 and round(hsize.y) > 0:
			get_node("Splitter/History/Light").set("position", Vector2(hsize.x / 2, hsize.y / 2))
			get_node("Splitter/History/Light").set("scale", Vector2(hsize.x, hsize.y))
