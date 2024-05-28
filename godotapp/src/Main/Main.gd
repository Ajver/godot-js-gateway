extends Node

@onready var ui = $UI


func _ready() -> void:
	JS_API.eval_file("res://src/Main/demo-js-app.js")
	GodotGateway.connect("event", _on_event)


func _on_event(e_name, e_data) -> void:
	match e_name:
		_:
			print("Unexpected event name: " + str(e_name))
