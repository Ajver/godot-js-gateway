extends Node

onready var ui = $UI


func _ready() -> void:
	GodotGateway.connect("event", self, "_on_event")


func _on_event(e_name, e_data) -> void:
	match e_name:
		"message":
			ui.show_message(e_data)
		_:
			push_error("Unexpected event name: " + str(e_name))
