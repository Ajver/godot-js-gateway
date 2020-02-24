extends Control

onready var msg_popup : AcceptDialog = $MessagePopup
onready var msg_text_edit : TextEdit = find_node("MessageTextEdit")


func _ready() -> void:
	GodotGateway.add_event_listener("message", self, "show_message")


func show_message(msg:String) -> void:
	msg_popup.dialog_text = msg
	msg_popup.popup()


func _on_GodotEvent_pressed():
	var msg : String = msg_text_edit.text
	GodotGateway.new_event("message_from_godot", msg)
