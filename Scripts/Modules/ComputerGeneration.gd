extends Node

var all_ports = ["SSH", "FTP", "WEB", "RTSP", "SMTP", "KBT", "TRNT", "SSL", "PAC"]
var rng = RandomNumberGenerator.new()

func _ready():
	pass # Replace with function body.


func _add_generated_difficulty(port_count, minimum_ports_required, proxy_firewall, length, trace_time, node_info):
	#First populate the computer with the amount of ports wanted 
	node_info = _add_ports(port_count, node_info)
	#Next, add the port amount required to sucessfully hack the computer
	node_info["ports_to_hack"] = rng.randi_range(minimum_ports_required, 
		port_count)
	return node_info

func _add_ports(port_count, node_info):
	var whitelisted_ports : Array
	var blacklisted_ports : Array
	#First check to see if there's a port whitelist, since that'll take priority
	if "whitelisted_ports" in node_info:
		if node_info["whitelisted_ports"].size() > 0:
			whitelisted_ports = node_info["whitelisted_ports"]
	#Blacklist is secondary, since it's exclusive rather than inclusive, so it'll be used less
	if "blacklisted_ports" in node_info:
		if node_info["blacklisted_ports"].size() > 0:
			blacklisted_ports = node_info["blacklisted_ports"]
	#Make sure that the whitelist isn't empty. Because that would be bad
	if whitelisted_ports.size() > 0:
		for _i in range(port_count):
			var current_port = whitelisted_ports[rng.randi_range(0,all_ports.size()-1)]
			node_info = _port_addition_check(current_port, node_info)
	#If the whitelist is empty, check to see if the blacklist isn't
	elif blacklisted_ports.size() > 0:
		var new_port_set = []
		#Make sure to remove the ports from the total list, if they're blacklisted
		for i in range(all_ports):
			if not all_ports[i] in blacklisted_ports:
				new_port_set.append(all_ports[i])
		for _i in range(port_count):
			var current_port = new_port_set[rng.randi_range(0,all_ports.size()-1)]
			node_info = _port_addition_check(current_port, node_info)
	#If you're blacklisting all ports or whitelisting none, just, do nothing I guess
	elif blacklisted_ports[0] == "ALL" or whitelisted_ports[0] == "NONE":
		pass
	#And if all else fails, just add in any random port
	else:
		for _i in range(port_count):
			var current_port = all_ports[rng.randi_range(0,all_ports.size()-1)]
			node_info = _port_addition_check(current_port, node_info)
	return node_info

func _port_addition_check(port, node_info):
	#First we randomly chose between a default port number and a randomized one
	if rng.randi(0,1) == 1:
		node_info["ports_available"].append([port, rng.randi_range(1,65535)])
	else:
	#If we pick the default port number, we have to check if we haven't already
	#Technically I should check to see if the port number is also the same,
	#but the potentional for a repeat is pretty small. You might even say it's
	#one in sixty five thousand five hundred thirty five, soo...
		if port in node_info["ports_available"]:
			node_info["ports_available"].append([port, rng.randi_range(1,65535)])
		else:
			node_info["ports_available"].append(port)
	return node_info

func _proxy_firewall_calculation(proxy_firewall, length, node_info):
	#Check to see the specifications for adding a firewall or a proxy
	#If it's anything besides 1-3, just determine it has no proxy or firewall
	#If it's one, add a proxy
	if proxy_firewall == 1:
		node_info = _add_proxy(length, node_info)
	#If it's two, add a firewall
	elif proxy_firewall == 2:
		node_info = _add_firewall(length, node_info)
	#If it's three, add both
	elif proxy_firewall == 3:
		node_info = _add_proxy(length, node_info)
		node_info = _add_firewall(length, node_info)
	return node_info

func _add_proxy(length, node_info):
	#Set having a proxy to true and set the time it takes for one shell to crack
	#it in seconds, only if it is not already defined. Each interval is 30 seconds
	node_info["has_proxy"] = true
	if not "proxy_length" in node_info or node_info["proxy_length"] == -1:
		node_info["proxy_length"] = 30 * length
	return node_info

func _add_firewall(length, node_info):
	var alpha_numeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var password = ""
	node_info["has_firewall"] = true
	if not "firewall_step_length" in node_info or node_info["firewall_step_length"] == -1:
		node_info["firewall_step_length"] = 1.25 * length
	#Generate a randomized password based on the length, and also calculate
	#how long it'll take to reveal each line in the firewall only if they are
	#not already defined.
	if not "firewall_solution" in node_info or node_info["firewall_solution"] == "":
		for _i in range(6 + length):
			password += alpha_numeric[rng.randi_range(0,len(alpha_numeric)-1)]
		node_info["firewall_solution"] = password
	return node_info
