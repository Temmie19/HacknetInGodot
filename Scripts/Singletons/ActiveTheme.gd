extends Node

var cur_theme : Dictionary
var theme_name : String
var wallpaper_type : String

var module_background : Color
var module_text : Color

var button_highlight_on : Color = Color("2a4183")
var button_highlight_off : Color = Color("7e3d3d")
var button_base : Color = Color("7e3d3d")
var button_border : Color = Color("2a4183")
var button_border_hover : Color = Color(0.84, 0.66, 0.14, 1)

var top_bar : Color
var top_bar_highlight: Color
var top_bar_icons : Color
var top_bar_text : Color

var text_color : Color
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("theme_change", self, "_on_theme_changed")

func _on_theme_changed(theme):
	cur_theme = theme
	_load_theme()

func _load_theme():
	for val in cur_theme:
		self[val] = cur_theme[val]
