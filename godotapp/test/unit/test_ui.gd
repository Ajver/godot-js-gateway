extends "res://addons/gut/test.gd"

var UI = preload("res://src/UI/UI.tscn")
var ui : Control = null
var msg_popup : Popup = null 


func before_each() -> void:
	ui = UI.instance()
	add_child(ui)
	msg_popup = ui.find_node("MessagePopup")


func after_each() -> void:
	ui.free()


func test_popup_invisible_by_default() -> void:
	assert_false(msg_popup.visible)


func test_show_message_shows_popup() -> void:
	ui.show_message("message_text")
	assert_true(msg_popup.visible)


func test_show_message_sets_text() -> void:
	ui.show_message("message_text")
	assert_eq("message_text", msg_popup.dialog_text)