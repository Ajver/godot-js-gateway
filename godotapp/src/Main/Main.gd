extends Node

onready var ui = $UI


func _ready() -> void:
	GodotGateway.connect("event", self, "_on_event")


func _on_event(e_name, e_data) -> void:
	match e_name:
		_:
			print("Unexpected event name: " + str(e_name))
