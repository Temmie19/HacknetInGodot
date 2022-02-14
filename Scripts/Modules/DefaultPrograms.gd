extends Node

var config = ConfigFile.new()

var terminal_node = Status.base_scene.get_node("VSplitContainer/Interfaces/MainSplitter/Terminal")
var history = terminal_node.get_node("Splitter/History")
var location = terminal_node.get_node("Splitter/CommandBar/Location")
var entry = terminal_node.get_node("Splitter/CommandBar/CommandEntry")

func _clear_history():
	#Resets the entire terminal history. Nice and simple
	history.set_text("")
	_erase()
	terminal_node.line_count = 0
	for _i in range(terminal_node.total_lines):
		history.newline()

func _erase():
	#The stunning sequel
	entry.set_text("")

func _ls(post_command:Array):
	#ls, like the real command, will list all the files in a directory. Or in 
	#this case, all the entries in the filesystem dictionary
	#Start by setting the active filesystem to root and parsing the location
	#the player wants to run the command in, checking to see if a computer is
	#actually available to connect to. Otherwise fail the check and return error
	if typeof(Status.active_computer) == TYPE_NIL:
		terminal_node._display_previous_command()
		_erase()
		terminal_node._add_to_terminal(str("Cannot list contents of filesystem. ",\
		"Please connect to a computer and try again.\n"))
		return
	var active_filesystem = Status.active_computer.filesystem
	var location
	if post_command.size() == 0:
		location = Status.current_directory
	elif post_command[0][0] == "/":
		location = post_command[0]
		print("Started from the top")
	else:
		location = Status.current_directory + post_command[0]
	var parsed_location : Array = _location_parser(location)
	var files = []
	var folders = []
	#Next, check to see if the parsed location is greater than 1, meaning it's
	#not in the root directory "/", because then we need to check if the whole
	#path exists and is valid
	if parsed_location.size() > 1:
		var location_check = active_filesystem
		var location_string = "/"
		#For each section of the location, we're going to check if it's both
		#existent and a valid folder, not a file
		for loc in parsed_location:
			#Check to see if it's the root directory, and if not run checks
			if not loc == "/":
				loc += "/"
				#If it doesn't exist, make the error and return it
				if not loc in location_check:
					terminal_node._display_previous_command()
					_erase()
					terminal_node._add_to_terminal(str(location_string, " does not exist!\n"))
					return
				#If it's not a dictionary, meaning it's not a folder, return an error
				elif not typeof(location_check[loc]) == TYPE_DICTIONARY:
					terminal_node._display_previous_command()
					_erase()
					terminal_node._add_to_terminal(str(location_string, " is not a valid directory!\n"))
					return
				#This section is important because this is how we check the next
				#layer every time
				else:
					location_check = location_check[loc]
					location_string += loc + "/"
		#If everything succeeds, set the active filesystem to the correct 
		#dictionary/directory
		active_filesystem = location_check
	#Next we get all the names of all the items in the dictionary, then check
	#to see if those items are themselves dictionaries. If they are, add the
	#name with a slash to the folders array, and if not add the name to the
	#files array
	var keys = active_filesystem.keys()
	for key in keys:
		if typeof(active_filesystem[key]) == TYPE_DICTIONARY:
			folders.append(str(key + "/"))
		else:
			files.append(key)
	#Create a new array out of the sorted folders and files arrays, going 
	#alphabetically with the folders first, and then alphabetically with the
	#files second. Then adding the names to the terminal
	folders.sort()
	files.sort()
	var sorted = folders + files
	if sorted.size() == 0:
		sorted.append("")
	terminal_node._display_previous_command()
	_erase()
	for i in range(sorted.size()):
		terminal_node._add_to_terminal(str(sorted[i] + "\n"))

func _location_parser(location:String):
	#So this is to parse a location so I know where to do it on the computer.
	#Basically just to make sure it's all good with the file system since it's 
	#all dictionaries when could theoretically get a little messy.
	#Start by splitting the string into chunks in an array
	var split = location.split("/", false)
	#Since "/" is the root directory, make sure I have that listed at all times
	var processed = ["/"]
	for chunk in split:
		#Check to see if we're going backwards with ".." but also make sure that
		#there's a folder to go to, so we don't accidentally remove the root
		#directory and break everything
		if chunk == "..":
			if processed.size() > 1:
				processed.pop_back()
		#If not going backwards, check to see if we're going nowhere
		elif chunk == ".":
			pass
		#And finally, if neither of those, add the chunk to the array since that
		#means we're going down a folder, though I should probably write a catch
		#somewhere that looks to see if that folder actually exists. Or maybe
		#it'll be per program to handle that. I dunno
		else:
			processed.append(chunk)
	return processed
