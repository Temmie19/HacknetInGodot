extends Node

signal connected(id, cname, ip)
signal disconnected(ip)
signal changed_directory(location)
signal nodemap_resized(containerXY)
signal theme_change(theme)
signal theme_load(theme)
signal command_run(command, data)
signal portcrusher_run(crusher, data)
signal program_run(program, data)
