extends Node

signal event(name, data)

# Structure of the dictionary:
# KEYS: events names
# VARS: array of arrays, with target node and target function
#
# Behaviour:
# On 'event_name' event, the 'func_name' is called on the 'node'
# 	{
#		"event_name": [
#			[ node:Node, func_name:String ],
#			...
#		],
#		...
# 	}
var _event_listeners : Dictionary = {}


func new_event(e_name:String, e_data:String) -> void:
	JS_API.call_function("gatewayToJS.newEvent", [e_name, e_data])


func _call_func(func_name:String):
	return JS_API.call_function("gatewayToGodot." + func_name)


func _ready() -> void:
	GodotGateway.call_deferred("_check_gateways_and_create_ready_event")


func _check_gateways_and_create_ready_event() -> void:
	if not JS_API.variable_exist("gatewayToGodot"):
		push_warning("Gateway to Godot is undefined. Events will not be processed")
		GodotGateway.set_process(false)
		
	if not JS_API.variable_exist("gatewayToJS"):
		push_warning("Gateway to JS is undefined. 'new_event' function will not work")
	else:
		GodotGateway.call_deferred("new_event", "ready", "")


func _process(delta) -> void:
	if GodotGateway._call_func("hasEvent"):
		GodotGateway._process_events()


func _process_events() -> void:
	while GodotGateway._call_func("hasEvent"):
		var e_name = GodotGateway._call_func("getCurrentEventName")
		var e_data = GodotGateway._call_func("getCurrentEventData")
		
		emit_signal("event", e_name, e_data)
		_call_listeners(e_name, e_data)
		
		GodotGateway._call_func("next")
		
	GodotGateway._call_func("clearEventsArray")


func _call_listeners(e_name:String, e_data) -> void:
	if not _event_listeners.has(e_name):
		return
	
	var arr : Array = _event_listeners[e_name] 
	for row in arr:
		var node : Node = row[0]
		var func_name : String = row[1]
		node.call(func_name, e_data)


func add_event_listener(e_name:String, node:Node, func_name:String) -> void:
	if not _event_listeners.has(e_name):
		_event_listeners[e_name] = []
	
	var arr : Array = _event_listeners[e_name] 
	arr.push_back([node, func_name])


func has_event_listener(e_name:String, node:Node, func_name:String) -> bool:
	if not _event_listeners.has(e_name):
		return false
	
	var arr : Array = _event_listeners[e_name] 
	for row in arr:
		if row[0] == node:
			if row[1] == func_name:
				return true
	
	return false
