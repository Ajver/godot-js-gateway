extends "res://addons/gut/test.gd"

class FakeNode:
	extends Node
	
	var test_func_called := false
	var test_data := ""
	
	var other_test_func_called := false
	var other_test_data := ""
	
	func _on_test_event(e_data:String) -> void:
		test_func_called = true
		test_data = e_data
	
	func _on_other_test_event(e_data:String) -> void:
		other_test_func_called = true
		other_test_data = e_data


func test_hasnt_listener_by_default() -> void:
	var fake_class_inst = _get_fake_class_inst()
	assert_false(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))


func test_add_event_listener() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	assert_true(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))


func test_multiple_event_listeners_to_THE_SAME_event_on_the_same_node() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	GodotGateway.add_event_listener("test_event", fake_class_inst, "_on_other_test_event")
	assert_true(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))
	assert_true(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_other_test_event"))


func test_multiple_event_listeners_to_DIFFERENT_event_on_the_same_node() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	GodotGateway.add_event_listener("another_test_event", fake_class_inst, "_on_other_test_event")
	assert_true(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))
	assert_true(GodotGateway.has_event_listener("another_test_event", fake_class_inst, "_on_other_test_event"))


func test_event_listener_called() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	GodotGateway._call_listeners("test_event", "test_data") 
	assert_true(fake_class_inst.test_func_called)


func test_NOT_call_other_events() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	GodotGateway.add_event_listener("another_test_event", fake_class_inst, "_on_other_test_event")
	GodotGateway._call_listeners("test_event", "test_data") 
	assert_true(fake_class_inst.test_func_called)
	assert_false(fake_class_inst.other_test_func_called)


func _get_fake_class_inst_connected_to_gateway() -> FakeNode:
	var fake_class_inst = _get_fake_class_inst()
	GodotGateway.add_event_listener("test_event", fake_class_inst, "_on_test_event")
	return fake_class_inst


func _get_fake_class_inst() -> FakeNode:
	return FakeNode.new()

