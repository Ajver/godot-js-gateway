extends Node

@onready var msg_popup : AcceptDialog = find_child("MessagePopup")
@onready var msg_text_edit : TextEdit = find_child("MessageTextEdit")
@onready var send_godot_event_btn: Button = find_child("SendGodotEventBtn")


func _ready() -> void:
	send_godot_event_btn.pressed.connect(_on_send_godot_event_btn_pressed)
	JS_API.eval_file("res://src/Main/demo-js-app.js")
	GodotGateway.event.connect(_on_event)
	
	GodotGateway.add_event_listener("message_from_js", show_message)


func _on_event(e_name, e_data) -> void:
	# General all events listener
	match e_name:
		_:
			print("Got event: ", e_name, " data: ", e_data)


func show_message(msg:String) -> void:
	msg_popup.dialog_text = msg
	msg_popup.popup_centered()


func _on_send_godot_event_btn_pressed():
	var msg : String = msg_text_edit.text
	GodotGateway.new_event("message_from_godot", msg)
