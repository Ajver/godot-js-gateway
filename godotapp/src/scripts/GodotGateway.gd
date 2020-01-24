extends Node

signal event(name, data)

func new_event(e_name:String, e_data:String) -> void:
	JS_API.call_function("gatewayToJS.newEvent", [e_name, e_data])


func _call_func(func_name:String):
	return JS_API.call_function("gatewayToGodot." + func_name)


func _ready():
	GodotGateway.call_deferred("new_event", 'ready', '')


func _process(delta):
	if GodotGateway._call_func("hasEvent"):
		GodotGateway._process_events()


func _process_events() -> void:
	while GodotGateway._call_func("hasEvent"):
		var e_name = GodotGateway._call_func("getCurrentEventName")
		var e_data = GodotGateway._call_func("getCurrentEventData")
		
		emit_signal("event", e_name, e_data)
		
		GodotGateway._call_func("next")
		
	GodotGateway._call_func("clearEventsArray")
