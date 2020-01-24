extends Node

func eval(js_code:String):
	if OS.has_feature("JavaScript"):
		return JavaScript.eval(js_code)
	else:
		return null

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
	
