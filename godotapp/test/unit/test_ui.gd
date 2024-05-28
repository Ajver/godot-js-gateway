extends GutTest

var MainScene = preload("res://src/Main/Main.tscn")
var main : Node = null
var msg_popup : AcceptDialog = null 


func before_each() -> void:
	main = MainScene.instantiate()
	add_child(main)
	msg_popup = main.find_child("MessagePopup")


func after_each() -> void:
	GodotGateway.remove_event_listener("message", main.show_message)
	main.free()


func test_popup_invisible_by_default() -> void:
	assert_false(msg_popup.visible)


func test_show_message_shows_popup() -> void:
	main.show_message("message_text")
	assert_true(msg_popup.visible)


func test_show_message_sets_text() -> void:
	main.show_message("message_text")
	assert_eq("message_text", msg_popup.dialog_text)


func test_shows_popup_on_event_from_js() -> void:
	GodotGateway._call_listeners("message_from_js", "message from fake JS")
	assert_eq("message from fake JS", msg_popup.dialog_text)
