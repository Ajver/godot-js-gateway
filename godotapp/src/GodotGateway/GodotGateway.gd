extends Node

signal event(name, data)

# Structure of the dictionary:
# KEYS: events names
# VARS: array of callbacks to call when the event occurs
#
# Behaviour:
# On 'event_name' event, 
# 	{
#		"event_name": [
#			Callable,
#			...
#		],
#		...
# 	}
var _event_listeners : Dictionary = {}


func _ready() -> void:
	JS_API.eval_file("res://src/GodotGateway/GodotGateway.js")
	GodotGateway.call_deferred("_check_gateways_and_create_ready_event")


func new_event(e_name:String, e_data:String) -> void:
	JS_API.call_function("document.gatewayToJS.newEvent", [e_name, e_data])


func _call_func(func_name:String):
	return JS_API.call_function("document.gatewayToGodot." + func_name)


func _check_gateways_and_create_ready_event() -> void:
	if not JS_API.variable_exist("document.gatewayToGodot"):
		push_warning("Gateway to Godot is undefined. Events will not be processed")
		GodotGateway.set_process(false)
		
	if not JS_API.variable_exist("document.gatewayToJS"):
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
	for listener: Callable in arr:
		listener.call(e_data)


func add_event_listener(e_name:String, listener: Callable) -> void:
	if not _event_listeners.has(e_name):
		_event_listeners[e_name] = []
	
	var arr : Array = _event_listeners[e_name] 
	arr.push_back(listener)


func remove_event_listener(e_name:String, listener: Callable) -> void:
	if not _event_listeners.has(e_name):
		return
	
	var arr : Array = _event_listeners[e_name]
	var i := 0
	for cb in arr:
		if cb == listener:
			arr.remove_at(i)
		else:
			i += 1


func has_event_listener(e_name:String, listener: Callable) -> bool:
	if not _event_listeners.has(e_name):
		return false
	
	var arr : Array = _event_listeners[e_name] 
	for cb in arr:
		if cb == listener:
			return true
	
	return false
