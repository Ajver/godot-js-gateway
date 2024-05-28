extends Node

var _is_available: bool = false


func _init():
	_is_available = OS.has_feature("web")


func eval(js_code:String, global_context: bool = false):
	if is_available():
		return JavaScriptBridge.eval(js_code, global_context)
	else:
		return null


func eval_file(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		printerr("No file at path: " + file_path)
		return

	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)

	if FileAccess.get_open_error() != OK:
		printerr("Couldn't open file from path: " + file_path)
		return

	var content := file.get_as_text()
	eval(content)

	file.close()


func call_function(func_name:String, params_array:Array = []):
	var params_str := params_array_to_str(params_array)
	var func_str = str(func_name, "(", params_str, ");")
	return JS_API.eval(func_str)


func params_array_to_str(params_array:Array) -> String:
	var params_str := ""
	var params_count := params_array.size()
	
	for i in range(params_count-1):
		var p = params_array[i]
		params_str += "'" + p + "'" + ", "
		
	if params_count > 0:
		params_str += "'" + params_array[params_count-1] + "'"
	
	return params_str


func variable_exist(variable:String) -> bool:
	var eval_str = "(typeof " + variable + " !== 'undefined')"
	var eval_return = JS_API.eval(eval_str, true)
	return eval_return and bool(eval_return)


func is_available():
	return _is_available
