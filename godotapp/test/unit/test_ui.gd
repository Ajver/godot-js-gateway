extends GutTest

var UI = preload("res://src/UI/UI.tscn")
var ui : Control = null
var msg_popup : AcceptDialog = null 


func before_each() -> void:
	ui = UI.instantiate()
	add_child(ui)
	msg_popup = ui.find_child("MessagePopup")


func after_each() -> void:
	GodotGateway.remove_event_listener("message", ui.show_message)
	ui.free()


func test_popup_invisible_by_default() -> void:
	assert_false(msg_popup.visible)


func test_show_message_shows_popup() -> void:
	ui.show_message("message_text")
	assert_true(msg_popup.visible)


func test_show_message_sets_text() -> void:
	ui.show_message("message_text")
	assert_eq("message_text", msg_popup.dialog_text)


func test_shows_popup_on_event_from_js() -> void:
	GodotGateway._call_listeners("message", "message from fake JS")
	assert_eq("message from fake JS", msg_popup.dialog_text)
