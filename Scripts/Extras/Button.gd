extends Panel

onready var panel = get_node(".")
onready var highlight = get_node("ButtonContainer/Highlight")
onready var label = get_node("ButtonContainer/Base/Label")

onready var style_box = panel.get_stylebox("panel").duplicate()

var hover_active = false
export var is_active : bool = false
var button_text = ""

var border = ActiveTheme.button_border
var border_hover = ActiveTheme.button_border_hover

func _ready():
	_load_theme()
	label.set_text(button_text)

func _load_theme():
	_check_active()
	_set_border_colors()

func _check_active():
	#This just makes it so that when a button is available for a user to press, its colour is
	#different. Just like in the original game
	if is_active == true:
		highlight.color = ActiveTheme.button_highlight_on
	else:
		highlight.color = ActiveTheme.button_highlight_off

func _process(delta):
	#This runs every frame, and we want to make sure that the mouse is within the barrier of the
	#button
	if panel.get_global_rect().has_point(get_global_mouse_position()):
		#If it is, and hover_active is false, set hover active to true and update the colour to be
		#the hover colour. We want the hover active gate so we don't waste a ton of resources every
		#frame trying to redraw the buttons
		if not hover_active:
			style_box.border_color = border_hover
			hover_active = true
	else:
		#Else if hover_active is true, set the border colour back to the normal colour and set
		#hover_active back to false to not waste resources
		if hover_active:
			style_box.border_color = border
			hover_active = false

func _set_border_colors():
	#First we want to make sure that we set the default border colour, or else it'll just be a dull gray
	style_box.border_color = border
	#Then we want to override the stylebox to the panel. This one command has a lot of grievance towards
	#me because I tried a dozen different ways to override the stylebox, and the only way I found out
	#how to do it was with a single comment on a Github bug report thread which I will link below.
	#(https://github.com/godotengine/godot/issues/1431#issuecomment-674373575)
	panel.add_stylebox_override("panel", style_box)
