GDPC                0                                                                      -   P   res://.godot/exported/133200997/export-27f512e188e08a58eb1114c3e988d63a-UI.scn  p     ^      5�{��	K"|�W�F5    T   res://.godot/exported/133200997/export-2f0cb05a5e71328ea0af1eb4f93c4e22-GutScene.scn@"     @      ��"ݐ&ɔ�Kظe��    P   res://.godot/exported/133200997/export-38fb2aac5dc229383fa67c43b4feb490-Gut.scn `     �      ǁ�4�we����73    X   res://.godot/exported/133200997/export-7cf3fd67ad9f55210191d77b582b8209-default_env.res  !     �	      Ӧ�������}[    P   res://.godot/exported/133200997/export-cf5c0f3eefc21238175e70fce704a2c9-Main.scnp�     O      &�e��L�*�5���    ,   res://.godot/global_script_class_cache.cfg  �6            ��Р�8���8~$}P�    D   res://.godot/imported/icon.png-487276ed1e3a0c39cad0279d744ee560.ctex�*     	      �̷������~��9�N�    D   res://.godot/imported/icon.png-91b084043b8aaf2f1c906e7b9fa92969.ctex�z     �       G�����!����af�    T   res://.godot/imported/source_code_pro.fnt-042fb383b3c7b4c19e67c852f7fbefca.fontdata p�     _      ��Z!B����H�^�       res://.godot/uid_cache.bin  `D     �       �x�u說�����Hף       res://addons/gut/GutScene.gd�      �!      �K��c�V�zus\$M    $   res://addons/gut/GutScene.tscn.remap�4     e       -L���N9�K���       res://addons/gut/doubler.gd         r8      v_����UY��fSM!J       res://addons/gut/gut.gd �8      ��      �Wa�����I�w���        res://addons/gut/gut_cmdln.gd   �>     �6      �ʵ� �~�P��        res://addons/gut/gut_plugin.gd  u     �      R��ݨ��q{���'�n        res://addons/gut/hook_script.gd �v     F      ��Tzg��F^l����        res://addons/gut/icon.png.import�{     �       �X���_!<1�w       res://addons/gut/logger.gd  `|     Y      ����'�5&��2        res://addons/gut/method_maker.gd��     �      �]�q>� �Ғ�15��        res://addons/gut/one_to_many.gd P�     D      ���[o�QM��Uͷ       res://addons/gut/optparse.gd��      !      &`T�/�,KZN���S�    $   res://addons/gut/signal_watcher.gd  ��     �      ��W0�?���-�    ,   res://addons/gut/source_code_pro.fnt.import ��     �       ��Qda�6��T�a=:       res://addons/gut/spy.gd ��     �	      =����GT�}:��t�        res://addons/gut/stub_params.gd @�     
      �w�M�F3��c��%�       res://addons/gut/stubber.gd P�     �      ����,g���<�GJ�       res://addons/gut/summary.gd P     �      ����3kt�c���CL4       res://addons/gut/test.gd@      �      ٫�s}��%�f���i�F    $   res://addons/gut/test_collector.gd  @�           �ѤMR���1����    $   res://addons/gut/thing_counter.gd   P�           ��I��|�:ٓ~QT       res://addons/gut/utils.gd   `�           ҒB��L��x��       res://default_env.tres.remapP6     h       cXv�S��P�O�Tq�o       res://icon.png  �6     v      ge��@o�7�|AZ       res://icon.png.import   �3     �       ��kJ��C�h�TC�       res://project.binary@E     �      ��u9���m6�ʃL��       res://src/Main/Main.gd  ��     �       �УD��c�ܕD)��C�        res://src/Main/Main.tscn.remap   5     a       ĩɮi�k[�E�T���       res://src/UI/UI.gd  �     �      �#p���%r�3��
       res://src/UI/UI.tscn.remap  �5     _       ~Z������ܺ=��    $   res://src/scripts/GodotGateway.gd   ��     (
      _Բ��T+C���Cݾ       res://src/scripts/JS_API.gd ��     �      ��/��[`@��� uia[       res://test/Gut.tscn.remap   �5     `       �*c�
f���N���t^    $   res://test/unit/test_GodotGateway.gd�     *      Ș���R[�&���#       res://test/unit/test_ui.gd        Q      ����`�Yw1T8����    # ------------------------------------------------------------------------------
# Utility class to hold the local and built in methods separately.  Add all local
# methods FIRST, then add built ins.
# ------------------------------------------------------------------------------
class ScriptMethods:
	# List of methods that should not be overloaded when they are not defined
	# in the class being doubled.  These either break things if they are
	# overloaded or do not have a "super" equivalent so we can't just pass
	# through.
	var _blacklist = [
		'has_method',
		'get_script',
		'get',
		'_notification',
		'get_path',
		'_enter_tree',
		'_exit_tree',
		'_process',
		'_draw',
		'_physics_process',
		'_input',
		'_unhandled_input',
		'_unhandled_key_input',
		'_set',
		'_get', # probably
		'emit_signal', # can't handle extra parameters to be sent with signal.
		'draw_mesh', # issue with one parameter, value is `Null((..), (..), (..))``
		'_to_string', # nonexistant function ._to_string
	]

	var built_ins = []
	var local_methods = []
	var _method_names = []

	func is_blacklisted(method_meta):
		return _blacklist.find(method_meta.name) != -1

	func _add_name_if_does_not_have(method_name):
		var should_add = _method_names.find(method_name) == -1
		if(should_add):
			_method_names.append(method_name)
		return should_add

	func add_built_in_method(method_meta):
		var did_add = _add_name_if_does_not_have(method_meta.name)
		if(did_add and !is_blacklisted(method_meta)):
			built_ins.append(method_meta)

	func add_local_method(method_meta):
		var did_add = _add_name_if_does_not_have(method_meta.name)
		if(did_add):
			local_methods.append(method_meta)

	func to_s():
		var text = "Locals\n"
		for i in range(local_methods.size()):
			text += str("  ", local_methods[i].name, "\n")
		text += "Built-Ins\n"
		for i in range(built_ins.size()):
			text += str("  ", built_ins[i].name, "\n")
		return text

# ------------------------------------------------------------------------------
# Helper class to deal with objects and inner classes.
# ------------------------------------------------------------------------------
class ObjectInfo:
	var _path = null
	var _subpaths = []
	var _utils = load('res://addons/gut/utils.gd').new()
	var _method_strategy = null
	var make_partial_double = false
	var scene_path = null
	var _native_class = null
	var _native_class_instance = null

	func _init(path, subpath=null):
		_path = path
		if(subpath != null):
			_subpaths = _utils.split_string(subpath, '/')

	# Returns an instance of the class/inner class
	func instantiate():
		var to_return = null
		if(is_native()):
			to_return = _native_class.new()
		else:
			to_return = get_loaded_class().new()
		return to_return

	# Can't call it get_class because that is reserved so it gets this ugly name.
	# Loads up the class and then any inner classes to give back a reference to
	# the desired Inner class (if there is any)
	func get_loaded_class():
		var LoadedClass = load(_path)
		for i in range(_subpaths.size()):
			LoadedClass = LoadedClass.get(_subpaths[i])
		return LoadedClass

	func to_s():
		return str(_path, '[', get_subpath(), ']')

	func get_path():
		return _path

	func get_subpath():
		return _utils.join_array(_subpaths, '/')

	func has_subpath():
		return _subpaths.size() != 0

	func get_extends_text():
		var extend = null
		if(is_native()):
			extend = str("extends ", get_native_class_name())
		else:
			extend = str("extends '", get_path(), '\'')

		if(has_subpath()):
			extend += str('.', get_subpath().replace('/', '.'))

		return extend

	func get_method_strategy():
		return _method_strategy

	func set_method_strategy(method_strategy):
		_method_strategy = method_strategy

	func is_native():
		return _native_class != null

	func set_native_class(native_class):
		_native_class = native_class
		_native_class_instance = native_class.new()
		_path = _native_class_instance.get_class()

	func get_native_class_name():
		return _native_class_instance.get_class()

# ------------------------------------------------------------------------------
# START Doubler
# ------------------------------------------------------------------------------
var _utils = load('res://addons/gut/utils.gd').new()

var _output_dir = null
var _double_count = 0 # used in making files names unique
var _use_unique_names = true
var _spy = null
var  _ignored_methods = _utils.OneToMany.new()

var _stubber = _utils.Stubber.new()
var _lgr = _utils.get_logger()
var _method_maker = _utils.MethodMaker.new()
var _strategy = null


func _init(strategy=_utils.DOUBLE_STRATEGY.PARTIAL):
	# make sure _method_maker gets logger too
	set_logger(_utils.get_logger())
	_strategy = strategy

# ###############
# Private
# ###############
func _get_indented_line(indents, text):
	var to_return = ''
	for i in range(indents):
		to_return += "\t"
	return str(to_return, text, "\n")


func _stub_to_call_super(obj_info, method_name):
	var path = obj_info.get_path()
	if(obj_info.scene_path != null):
		path = obj_info.scene_path
	var params = _utils.StubParams.new(path, method_name, obj_info.get_subpath())
	params.to_call_super()
	_stubber.add_stub(params)


func _write_file(obj_info, dest_path, override_path=null):
	var script_methods = _get_methods(obj_info)

	var metadata = _get_stubber_metadata_text(obj_info)
	if(override_path):
		metadata = _get_stubber_metadata_text(obj_info, override_path)

	var f = File.new()
	var f_result = f.open(dest_path, f.WRITE)

	if(f_result != OK):
		print('Error creating file ', dest_path)
		print('Could not create double for :', obj_info.to_s())
		return

	f.store_string(str(obj_info.get_extends_text(), "\n"))
	f.store_string(metadata)

	for i in range(script_methods.local_methods.size()):
		if(obj_info.make_partial_double):
			_stub_to_call_super(obj_info, script_methods.local_methods[i].name)
		f.store_string(_get_func_text(script_methods.local_methods[i]))

	for i in range(script_methods.built_ins.size()):
		_stub_to_call_super(obj_info, script_methods.built_ins[i].name)
		f.store_string(_get_func_text(script_methods.built_ins[i]))

	f.close()


func _double_scene_and_script(scene_info, dest_path):
	var dir = DirAccess.new()
	dir.copy(scene_info.get_path(), dest_path)

	var inst = load(scene_info.get_path()).instantiate()
	var script_path = null
	if(inst.get_script()):
		script_path = inst.get_script().get_path()
	inst.free()

	if(script_path):
		var oi = ObjectInfo.new(script_path)
		oi.set_method_strategy(scene_info.get_method_strategy())
		oi.make_partial_double = scene_info.make_partial_double
		oi.scene_path = scene_info.get_path()
		var double_path = _double(oi, scene_info.get_path())
		var dq = '"'

		var f = File.new()
		f.open(dest_path, f.READ)
		var source = f.get_as_text()
		f.close()

		source = source.replace(dq + script_path + dq, dq + double_path + dq)

		f.open(dest_path, f.WRITE)
		f.store_string(source)
		f.close()

	return script_path

func _get_methods(object_info):
	var obj = object_info.instantiate()
	# any method in the script or super script
	var script_methods = ScriptMethods.new()
	var methods = obj.get_method_list()

	# first pass is for local methods only
	for i in range(methods.size()):
		# 65 is a magic number for methods in script, though documentation
		# says 64.  This picks up local overloads of base class methods too.
		if(methods[i].flags == 65 and !_ignored_methods.has(object_info.get_path(), methods[i]['name'])):
			script_methods.add_local_method(methods[i])


	if(object_info.get_method_strategy() == _utils.DOUBLE_STRATEGY.FULL):
		# second pass is for anything not local
		for i in range(methods.size()):
			# 65 is a magic number for methods in script, though documentation
			# says 64.  This picks up local overloads of base class methods too.
			if(methods[i].flags != 65 and !_ignored_methods.has(object_info.get_path(), methods[i]['name'])):
				script_methods.add_built_in_method(methods[i])

	return script_methods

func _get_inst_id_ref_str(inst):
	var ref_str = 'null'
	if(inst):
		ref_str = str('instance_from_id(', inst.get_instance_id(),')')
	return ref_str

func _get_stubber_metadata_text(obj_info, override_path = null):
	var path = obj_info.get_path()
	if(override_path != null):
		path = override_path
	return "var __gut_metadata_ = {\n" + \
           "\tpath='" + path + "',\n" + \
		   "\tsubpath='" + obj_info.get_subpath() + "',\n" + \
		   "\tstubber=" + _get_inst_id_ref_str(_stubber) + ",\n" + \
		   "\tspy=" + _get_inst_id_ref_str(_spy) + "\n" + \
           "}\n"

func _get_spy_text(method_hash):
	var txt = ''
	if(_spy):
		var called_with = _method_maker.get_spy_call_parameters_text(method_hash)
		txt += "\t__gut_metadata_.spy.add_call(self, '" + method_hash.name + "', " + called_with + ")\n"
	return txt

func _get_func_text(method_hash):
	var ftxt = _method_maker.get_decleration_text(method_hash) + "\n"

	var called_with = _method_maker.get_spy_call_parameters_text(method_hash)
	ftxt += _get_spy_text(method_hash)

	if(_stubber and method_hash.name != '_init'):
		var call_method = _method_maker.get_super_call_text(method_hash)
		ftxt += "\tif(__gut_metadata_.stubber.should_call_super(self, '" + method_hash.name + "', " + called_with + ")):\n"
		ftxt += "\t\treturn " + call_method + "\n"
		ftxt += "\telse:\n"
		ftxt += "\t\treturn __gut_metadata_.stubber.get_return(self, '" + method_hash.name + "', " + called_with + ")\n"
	else:
		ftxt += "\tpass\n"

	return ftxt

func _get_super_func_text(method_hash):
	var call_method = _method_maker.get_super_call_text(method_hash)

	var call_super_text = str("return ", call_method, "\n")

	var ftxt = _method_maker.get_decleration_text(method_hash) + "\n"
	ftxt += _get_spy_text(method_hash)

	ftxt += _get_indented_line(1, call_super_text)

	return ftxt

# returns the path to write the double file to
func _get_temp_path(object_info):
	var file_name = null
	var extension = null
	if(object_info.is_native()):
		file_name = object_info.get_native_class_name()
		extension = 'gd'
	else:
		file_name = object_info.get_path().get_file().get_basename()
		extension = object_info.get_path().get_extension()

	if(object_info.has_subpath()):
		file_name += '__' + object_info.get_subpath().replace('/', '__')

	if(_use_unique_names):
		file_name += str('__dbl', _double_count, '__.', extension)
	else:
		file_name += '.' + extension

	var to_return = _output_dir.plus_file(file_name)
	return to_return

func _double(obj_info, override_path=null):
	var temp_path = _get_temp_path(obj_info)
	_write_file(obj_info, temp_path, override_path)
	_double_count += 1
	return temp_path


func _double_script(path, make_partial, strategy):
	var oi = ObjectInfo.new(path)
	oi.make_partial_double = make_partial
	oi.set_method_strategy(strategy)
	var to_return = load(_double(oi))

	return to_return

func _double_inner(path, subpath, make_partial, strategy):
	var oi = ObjectInfo.new(path, subpath)
	oi.set_method_strategy(strategy)
	oi.make_partial_double = make_partial
	var to_return = load(_double(oi))

	return to_return

func _double_scene(path, make_partial, strategy):
	var oi = ObjectInfo.new(path)
	oi.set_method_strategy(strategy)
	oi.make_partial_double = make_partial
	var temp_path = _get_temp_path(oi)
	_double_scene_and_script(oi, temp_path)

	return load(temp_path)

func _double_gdnative(native_class, make_partial, strategy):
	var oi = ObjectInfo.new(null)
	oi.set_native_class(native_class)
	oi.set_method_strategy(strategy)
	oi.make_partial_double = make_partial
	var to_return = load(_double(oi))

	return to_return



# ###############
# Public
# ###############
func get_output_dir():
	return _output_dir

func set_output_dir(output_dir):
	_output_dir = output_dir
	var d = DirAccess.new()
	d.make_dir_recursive(output_dir)

func get_spy():
	return _spy

func set_spy(spy):
	_spy = spy

func get_stubber():
	return _stubber

func set_stubber(stubber):
	_stubber = stubber

func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger
	_method_maker.set_logger(logger)

func get_strategy():
	return _strategy

func set_strategy(strategy):
	_strategy = strategy

func partial_double_scene(path, strategy=_strategy):
	return _double_scene(path, true, strategy)

# double a scene
func double_scene(path, strategy=_strategy):
	return _double_scene(path, false, strategy)

# double a script/object
func double(path, strategy=_strategy):
	return _double_script(path, false, strategy)

func partial_double(path, strategy=_strategy):
	return _double_script(path, true, strategy)

func partial_double_inner(path, subpath, strategy=_strategy):
	return _double_inner(path, subpath, true, strategy)

# double an inner class in a script
func double_inner(path, subpath, strategy=_strategy):
	return _double_inner(path, subpath, false, strategy)

# must always use FULL strategy since this is a native class and you won't get
# any methods if you don't use FULL
func double_gdnative(native_class):
	return _double_gdnative(native_class, false, _utils.DOUBLE_STRATEGY.FULL)

# must always use FULL strategy since this is a native class and you won't get
# any methods if you don't use FULL
func partial_double_gdnative(native_class):
	return _double_gdnative(native_class, true, _utils.DOUBLE_STRATEGY.FULL)

func clear_output_directory():
	var did = false
	if(_output_dir.find('user://') == 0):
		var d = DirAccess.new()
		var result = d.open(_output_dir)
		# BIG GOTCHA HERE.  If it cannot open the dir w/ erro 31, then the
		# directory becomes res:// and things go on normally and gut clears out
		# out res:// which is SUPER BAD.
		if(result == OK):
			d.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
			var f = d.get_next()
			while(f != ''):
				d.remove(f)
				f = d.get_next()
				did = true
	return did

func delete_output_directory():
	var did = clear_output_directory()
	if(did):
		var d = DirAccess.new()
		d.remove(_output_dir)

# When creating doubles a unique name is used that each double can be its own
# thing.  Sometimes, for testing, we do not want to do this so this allows
# you to turn off creating unique names for each double class.
#
# THIS SHOULD NEVER BE USED OUTSIDE OF INTERNAL GUT TESTING.  It can cause
# weird, hard to track down problems.
func set_use_unique_names(should):
	_use_unique_names = should

func add_ignored_method(path, method_name):
	_ignored_methods.add(path, method_name)

func get_ignored_methods():
	return _ignored_methods
              @tool
################################################################################
#(G)odot (U)nit (T)est class
#
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################
# View readme for usage details.
#
# Version 6.8.1
################################################################################
#extends "res://addons/gut/gut_gui.gd"
extends Control
var _version = '6.8.1'

var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()
# Used to prevent multiple messages for deprecated setup/teardown messages
var _deprecated_tracker = _utils.ThingCounter.new()

# ###########################
# Editor Variables
# ###########################
@export var _select_script: String = ''
@export var _tests_like: String = ''
@export var _inner_class_name: String = ''

@export var _run_on_load = false
@export var _should_maximize = false: get = get_should_maximize, set = set_should_maximize

@export var _should_print_to_console = true: get = get_should_print_to_console, set = set_should_print_to_console
@export var _log_level = 1: get = get_log_level, set = set_log_level # (int, 'Failures only', 'Tests and failures', 'Everything')
# This var is JUST used to expose this setting in the editor
# the var that is used is in the _yield_between hash.
@export var _yield_between_tests = true: get = get_yield_between_tests, set = set_yield_between_tests
@export var _disable_strict_datatype_checks = false: get = is_strict_datatype_checks_disabled, set = disable_strict_datatype_checks
# The prefix used to get tests.
@export var _test_prefix = 'test_'
@export var _file_prefix = 'test_'
@export var _file_extension = '.gd'
@export var _inner_class_prefix = 'Test'

@export var _temp_directory: String = 'user://gut_temp_directory'
@export var _export_path: String = '': get = get_export_path, set = set_export_path

@export var _include_subdirectories = false: get = get_include_subdirectories, set = set_include_subdirectories
# Allow user to add test directories via editor.  This is done with strings
# instead of an array because the interface for editing arrays is really
# cumbersome and complicates testing because arrays set through the editor
# apply to ALL instances.  This also allows the user to use the built in
# dialog to pick a directory.
@export var _directory1 = '' # (String, DIR)
@export var _directory2 = '' # (String, DIR)
@export var _directory3 = '' # (String, DIR)
@export var _directory4 = '' # (String, DIR)
@export var _directory5 = '' # (String, DIR)
@export var _directory6 = '' # (String, DIR)
@export var _double_strategy = _utils.DOUBLE_STRATEGY.PARTIAL: get = get_double_strategy, set = set_double_strategy # (int, 'FULL', 'PARTIAL')
@export var _pre_run_script = '': get = get_pre_run_script, set = set_pre_run_script # (String, FILE)
@export var _post_run_script = '': get = get_post_run_script, set = set_post_run_script # (String, FILE)
# The instance that is created from _pre_run_script.  Accessible from
# get_pre_run_script_instance.
var _pre_run_script_instance = null
var _post_run_script_instance = null # This is not used except in tests.

# ###########################
# Other Vars
# ###########################
const LOG_LEVEL_FAIL_ONLY = 0
const LOG_LEVEL_TEST_AND_FAILURES = 1
const LOG_LEVEL_ALL_ASSERTS = 2
const WAITING_MESSAGE = '/# waiting #/'
const PAUSE_MESSAGE = '/# Pausing.  Press continue button...#/'

var _script_name = null
var _test_collector = _utils.TestCollector.new()

# The instanced scripts.  This is populated as the scripts are run.
var _test_script_objects = []

var _waiting = false
var _done = false
var _is_running = false

var _current_test = null
var _log_text = ""

var _pause_before_teardown = false
# when true _pause_before_teardown will be ignored.  useful
# when batch processing and you don't want to watch.
var _ignore_pause_before_teardown = false
var _wait_timer = Timer.new()

var _yield_between = {
	should = false,
	timer = Timer.new(),
	after_x_tests = 5,
	tests_since_last_yield = 0
}

var _was_yield_method_called = false
# used when yielding to gut instead of some other
# signal.  Start with set_yield_time()
var _yield_timer = Timer.new()

var _unit_test_name = ''
var _new_summary = null

var _yielding_to = {
	obj = null,
	signal_name = ''
}

var _stubber = _utils.Stubber.new()
var _doubler = _utils.Doubler.new()
var _spy = _utils.Spy.new()
var _gui = null

const SIGNAL_TESTS_FINISHED = 'tests_finished'
const SIGNAL_STOP_YIELD_BEFORE_TEARDOWN = 'stop_yield_before_teardown'

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _init():
	# This min size has to be what the min size of the GutScene's min size is
	# but it has to be set here and not inferred i think.
	custom_minimum_size =Vector2(740, 250)

	add_user_signal(SIGNAL_TESTS_FINISHED)
	add_user_signal(SIGNAL_STOP_YIELD_BEFORE_TEARDOWN)
	add_user_signal('timeout')
	add_user_signal('done_waiting')
	_doubler.set_output_dir(_temp_directory)
	_doubler.set_stubber(_stubber)
	_doubler.set_spy(_spy)
	_doubler.set_logger(_lgr)
	_lgr.set_gut(self)

	_stubber.set_logger(_lgr)
	_test_collector.set_logger(_lgr)
	_gui = load('res://addons/gut/GutScene.tscn').instantiate()

# ------------------------------------------------------------------------------
# Initialize controls
# ------------------------------------------------------------------------------
func _ready():
	_lgr.info(str('using [', OS.get_user_data_dir(), '] for temporary output.'))

	set_process_input(true)

	add_child(_wait_timer)
	_wait_timer.set_wait_time(1)
	_wait_timer.set_one_shot(true)

	add_child(_yield_between.timer)
	_wait_timer.set_one_shot(true)

	add_child(_yield_timer)
	_yield_timer.set_one_shot(true)
	_yield_timer.connect('timeout', Callable(self, '_yielding_callback'))

	_setup_gui()

	add_directory(_directory1)
	add_directory(_directory2)
	add_directory(_directory3)
	add_directory(_directory4)
	add_directory(_directory5)
	add_directory(_directory6)

	if(_select_script != null):
		select_script(_select_script)

	if(_tests_like != null):
		set_unit_test_name(_tests_like)

	if(_run_on_load):
		test_scripts(_select_script == null)

	if(_should_maximize):
		maximize()

	# hide the panel that IS gut so that only the GUI is seen
	self.self_modulate = Color(1,1,1,0)
	show()
	var v_info = Engine.get_version_info()
	p(str('Godot version:  ', v_info.major,  '.',  v_info.minor,  '.',  v_info.patch))
	p(str('GUT version:  ', get_version()))


################################################################################
#
# GUI Events and setup
#
################################################################################
func _setup_gui():
	# This is how we get the size of the control to translate to the gui when
	# the scene is run.  This is also another reason why the min_rect_size
	# must match between both gut and the gui.
	_gui.size = self.size
	add_child(_gui)
	_gui.set_anchor(MARGIN_RIGHT, ANCHOR_END)
	_gui.set_anchor(MARGIN_BOTTOM, ANCHOR_END)
	_gui.connect('run_single_script', Callable(self, '_on_run_one'))
	_gui.connect('run_script', Callable(self, '_on_new_gui_run_script'))
	_gui.connect('end_pause', Callable(self, '_on_new_gui_end_pause'))
	_gui.connect('ignore_pause', Callable(self, '_on_new_gui_ignore_pause'))
	_gui.connect('log_level_changed', Callable(self, '_on_log_level_changed'))
	connect('tests_finished', Callable(_gui, 'end_run'))

func _add_scripts_to_gui():
	var scripts = []
	for i in range(_test_collector.scripts.size()):
		var s = _test_collector.scripts[i]
		var txt = ''
		if(s.has_inner_class()):
			txt = str(' - ', s.inner_class_name, ' (', s.tests.size(), ')')
		else:
			txt = str(s.get_full_name(), '  (', s.tests.size(), ')')
		scripts.append(txt)
	_gui.set_scripts(scripts)

func _on_run_one(index):
	clear_text()
	var indexes = [index]
	if(!_test_collector.scripts[index].has_inner_class()):
		indexes = _get_indexes_matching_path(_test_collector.scripts[index].path)
	_test_the_scripts(indexes)

func _on_new_gui_run_script(index):
	var indexes = []
	clear_text()
	for i in range(index, _test_collector.scripts.size()):
		indexes.append(i)
	_test_the_scripts(indexes)

func _on_new_gui_end_pause():
	_pause_before_teardown = false
	emit_signal(SIGNAL_STOP_YIELD_BEFORE_TEARDOWN)

func _on_new_gui_ignore_pause(should):
	_ignore_pause_before_teardown = should

func _on_log_level_changed(value):
	_log_level = value

#####################
#
# Events
#
#####################

# ------------------------------------------------------------------------------
# Timeout for the built in timer.  emits the timeout signal.  Start timer
# with set_yield_time()
# ------------------------------------------------------------------------------
func _yielding_callback(from_obj=false):
	if(_yielding_to.obj):
		_yielding_to.obj.call_deferred(
			"disconnect",
			_yielding_to.signal_name, self,
			'_yielding_callback')
		_yielding_to.obj = null
		_yielding_to.signal_name = ''

	if(from_obj):
		# we must yiled for a little longer after the signal is emitted so that
		# the signal can propagate to other objects.  This was discovered trying
		# to assert that obj/signal_name was emitted.  Without this extra delay
		# the yield returns and processing finishes before the rest of the
		# objects can get the signal.  This works b/c the timer will timeout
		# and come back into this method but from_obj will be false.
		_yield_timer.set_wait_time(.1)
		_yield_timer.start()
	else:
		emit_signal('timeout')

# ------------------------------------------------------------------------------
# completed signal for GDScriptFucntionState returned from a test script that
# has yielded
# ------------------------------------------------------------------------------
func _on_test_script_yield_completed():
	_waiting = false

#####################
#
# Private
#
#####################

# ------------------------------------------------------------------------------
# Convert the _summary dictionary into text
# ------------------------------------------------------------------------------
func _get_summary_text():
	var to_return = "\n\n*****************\nRun Summary\n*****************"

	to_return += "\n" + _new_summary.get_summary_text() + "\n"

	var logger_text = ''
	if(_lgr.get_errors().size() > 0):
		logger_text += str("\n  * ", _lgr.get_errors().size(), ' Errors.')
	if(_lgr.get_warnings().size() > 0):
		logger_text += str("\n  * ", _lgr.get_warnings().size(), ' Warnings.')
	if(_lgr.get_deprecated().size() > 0):
		logger_text += str("\n  * ", _lgr.get_deprecated().size(), ' Deprecated calls.')
	if(logger_text != ''):
		logger_text = "\nWarnings/Errors:" + logger_text + "\n\n"
	to_return += logger_text

	if(_new_summary.get_totals().tests > 0):
		to_return +=  '+++ ' + str(_new_summary.get_totals().passing) + ' passed ' + str(_new_summary.get_totals().failing) + ' failed.  ' + \
					  "Tests finished in:  " + str(_gui.get_run_duration()) + ' +++'
		var c = Color(0, 1, 0)
		if(_new_summary.get_totals().failing > 0):
			c = Color(1, 0, 0)
		elif(_new_summary.get_totals().pending > 0):
			c = Color(1, 1, .8)

		_gui.get_text_box().add_color_region('+++', '+++', c)
	else:
		to_return += '+++ No tests ran +++'
		_gui.get_text_box().add_color_region('+++', '+++', Color(1, 0, 0))

	return to_return

func _validate_hook_script(path):
	var result = {
		valid = true,
		instance = null
	}

	# empty path is valid but will have a null instance
	if(path == ''):
		return result

	var f = File.new()
	if(f.file_exists(path)):
		var inst = load(path).new()
		if(inst and inst is _utils.HookScript):
			result.instance = inst
			result.valid = true
		else:
			result.valid = false
			_lgr.error('The hook script [' + path + '] does not extend res://addons/gut/hook_script.gd')
	else:
		result.valid = false
		_lgr.error('The hook script [' + path + '] does not exist.')

	return result


# ------------------------------------------------------------------------------
# Runs a hook script.  Script must exist, and must extend
# res://addons/gut/hook_script.gd
# ------------------------------------------------------------------------------
func _run_hook_script(inst):
	if(inst != null):
		inst.gut = self
		inst.run()
	return inst

# ------------------------------------------------------------------------------
# Initialize variables for each run of a single test script.
# ------------------------------------------------------------------------------
func _init_run():
	var valid = true
	_test_collector.set_test_class_prefix(_inner_class_prefix)
	_test_script_objects = []
	_new_summary = _utils.Summary.new()

	_log_text = ""

	_current_test = null

	_is_running = true

	_yield_between.tests_since_last_yield = 0

	_gui.get_text_box().clear_colors()
	_gui.get_text_box().add_keyword_color("PASSED", Color(0, 1, 0))
	_gui.get_text_box().add_keyword_color("FAILED", Color(1, 0, 0))
	_gui.get_text_box().add_color_region('/#', '#/', Color(.9, .6, 0))
	_gui.get_text_box().add_color_region('/-', '-/', Color(1, 1, 0))
	_gui.get_text_box().add_color_region('/*', '*/', Color(.5, .5, 1))

	var  pre_hook_result = _validate_hook_script(_pre_run_script)
	_pre_run_script_instance = pre_hook_result.instance
	var post_hook_result = _validate_hook_script(_post_run_script)
	_post_run_script_instance  = post_hook_result.instance

	valid = pre_hook_result.valid and  post_hook_result.valid

	return valid




# ------------------------------------------------------------------------------
# Print out run information and close out the run.
# ------------------------------------------------------------------------------
func _end_run():
	var failed_tests = []
	var more_than_one = _test_script_objects.size() > 1

	p(_get_summary_text(), 0)
	p("\n")
	if(!_utils.is_null_or_empty(_select_script)):
		p('Ran Scripts matching ' + _select_script)
	if(!_utils.is_null_or_empty(_unit_test_name)):
		p('Ran Tests matching ' + _unit_test_name)
	if(!_utils.is_null_or_empty(_inner_class_name)):
		p('Ran Inner Classes matching ' + _inner_class_name)

	# For some reason the text edit control isn't scrolling to the bottom after
	# the summary is printed.  As a workaround, yield for a short time and
	# then move the cursor.  I found this workaround through trial and error.
	_yield_between.timer.set_wait_time(0.1)
	_yield_between.timer.start()
	await _yield_between.timer.timeout
	_gui.get_text_box().set_caret_line(_gui.get_text_box().get_line_count())

	_is_running = false
	update()
	_run_hook_script(_post_run_script_instance)
	emit_signal(SIGNAL_TESTS_FINISHED)
	_gui.set_title("Finished.  " + str(get_fail_count()) + " failures.")

# ------------------------------------------------------------------------------
# Checks the passed in thing to see if it is a "function state" object that gets
# returned when a function yields.
# ------------------------------------------------------------------------------
func _is_function_state(script_result):
	return script_result != null and \
		   typeof(script_result) == TYPE_OBJECT and \
		   script_result is GDScriptFunctionState

# ------------------------------------------------------------------------------
# Print out the heading for a new script
# ------------------------------------------------------------------------------
func _print_script_heading(script):
	if(_does_class_name_match(_inner_class_name, script.inner_class_name)):
		p("\n/-----------------------------------------")
		if(script.inner_class_name == null):
			p("Running Script " + script.path, 0)
		else:
			p("Running Class [" + script.inner_class_name + "] in " + script.path, 0)

		if(!_utils.is_null_or_empty(_inner_class_name) and _does_class_name_match(_inner_class_name, script.inner_class_name)):
			p(str('  [',script.inner_class_name, '] matches [', _inner_class_name, ']'))

		if(!_utils.is_null_or_empty(_unit_test_name)):
			p('  Only running tests like: "' + _unit_test_name + '"')

		p("-----------------------------------------/")

# ------------------------------------------------------------------------------
# Just gets more logic out of _test_the_scripts.  Decides if we should yield after
# this test based on flags and counters.
# ------------------------------------------------------------------------------
func _should_yield_now():
	var should = _yield_between.should and \
				 _yield_between.tests_since_last_yield == _yield_between.after_x_tests
	if(should):
		_yield_between.tests_since_last_yield = 0
	else:
		_yield_between.tests_since_last_yield += 1
	return should

# ------------------------------------------------------------------------------
# Yes if the class name is null or the script's class name includes class_name
# ------------------------------------------------------------------------------
func _does_class_name_match(the_class_name, script_class_name):
	return (the_class_name == null or the_class_name == '') or (script_class_name != null and script_class_name.find(the_class_name) != -1)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _setup_script(test_script):
	test_script.gut = self
	test_script.set_logger(_lgr)
	add_child(test_script)
	_test_script_objects.append(test_script)


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _do_yield_between(time):
	_yield_between.timer.set_wait_time(time)
	_yield_between.timer.start()
	return _yield_between.timer

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _wait_for_done(result):
	var iter_counter = 0
	var print_after = 3

	# sets waiting to false.
	result.connect('completed', Callable(self, '_on_test_script_yield_completed'))

	if(!_was_yield_method_called):
		p('/# Yield detected, waiting #/')

	_was_yield_method_called = false
	_waiting = true
	_wait_timer.set_wait_time(0.25)

	while(_waiting):
		iter_counter += 1
		if(iter_counter > print_after):
			p(WAITING_MESSAGE, 2)
			iter_counter = 0
		_wait_timer.start()
		await _wait_timer.timeout

	emit_signal('done_waiting')

# ------------------------------------------------------------------------------
# returns self so it can be integrated into the yield call.
# ------------------------------------------------------------------------------
func _wait_for_continue_button():
	p(PAUSE_MESSAGE, 0)
	_waiting = true
	return self

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _call_deprecated_script_method(script, method, alt):
	if(script.has_method(method)):
		var txt = str(script, '-', method)
		if(!_deprecated_tracker.has(txt)):
			# Removing the deprecated line.  I think it's still too early to
			# start bothering people with this.  Left everything here though
			# because I don't want to remember how I did this last time.
			#_lgr.deprecated(str('The method ', method, ' has been deprecated, use ', alt, ' instead.'))
			_deprecated_tracker.add(txt)
		script.call(method)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _get_indexes_matching_script_name(name):
	var indexes = [] # empty runs all
	for i in range(_test_collector.scripts.size()):
		if(_test_collector.scripts[i].get_scene_file_path().find(name) != -1):
			indexes.append(i)
	return indexes

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _get_indexes_matching_path(path):
	var indexes = []
	for i in range(_test_collector.scripts.size()):
		if(_test_collector.scripts[i].path == path):
			indexes.append(i)
	return indexes

# ------------------------------------------------------------------------------
# Run all tests in a script.  This is the core logic for running tests.
#
# Note, this has to stay as a giant monstrosity of a method because of the
# yields.
# ------------------------------------------------------------------------------
func _test_the_scripts(indexes=[]):
	var is_valid = _init_run()
	if(!is_valid):
		_lgr.error('Something went wrong and the run was aborted.')
		emit_signal(SIGNAL_TESTS_FINISHED)
		return

	_run_hook_script(_pre_run_script_instance)
	if(_pre_run_script_instance!= null and _pre_run_script_instance.should_abort()):
		_lgr.error('pre-run abort')
		emit_signal(SIGNAL_TESTS_FINISHED)
		return

	_gui.run_mode()

	var indexes_to_run = []
	if(indexes.size()==0):
		for i in range(_test_collector.scripts.size()):
			indexes_to_run.append(i)
	else:
		indexes_to_run = indexes

	_gui.set_progress_script_max(indexes_to_run.size()) # New way
	_gui.set_progress_script_value(0)

	var file = File.new()
	if(_doubler.get_strategy() == _utils.DOUBLE_STRATEGY.FULL):
		_lgr.info("Using Double Strategy FULL as default strategy.  Keep an eye out for weirdness, this is still experimental.")

	# loop through scripts
	for test_indexes in range(indexes_to_run.size()):
		var the_script = _test_collector.scripts[indexes_to_run[test_indexes]]

		if(the_script.tests.size() > 0):
			_gui.set_title('Running:  ' + the_script.get_full_name())
			_print_script_heading(the_script)
			_new_summary.add_script(the_script.get_full_name())

		var test_script = the_script.get_new()
		var script_result = null
		_setup_script(test_script)
		_doubler.set_strategy(_double_strategy)

		# yield between test scripts so things paint
		if(_yield_between.should):
			await _do_yield_between(0.01).timeout

		# !!!
		# Hack so there isn't another indent to this monster of a method.  if
		# inner class is set and we do not have a match then empty the tests
		# for the current test.
		# !!!
		if(!_does_class_name_match(_inner_class_name, the_script.inner_class_name)):
			the_script.tests = []
		else:
			# call both pre-all-tests methods until prerun_setup is removed
			_call_deprecated_script_method(test_script, 'prerun_setup', 'before_all')
			test_script.before_all()

		_gui.set_progress_test_max(the_script.tests.size()) # New way

		# Each test in the script
		for i in range(the_script.tests.size()):
			_stubber.clear()
			_spy.clear()
			_doubler.clear_output_directory()
			_current_test = the_script.tests[i]

			if((_unit_test_name != '' and _current_test.name.find(_unit_test_name) > -1) or
				(_unit_test_name == '')):
				p(_current_test.name, 1)
				_new_summary.add_test(_current_test.name)

				# yield so things paint
				if(_should_yield_now()):
					await _do_yield_between(0.001).timeout

				_call_deprecated_script_method(test_script, 'setup', 'before_each')
				test_script.before_each()


				#When the script yields it will return a GDScriptFunctionState object
				script_result = test_script.call(_current_test.name)
				if(_is_function_state(script_result)):
					_wait_for_done(script_result)
					await self.done_waiting

				#if the test called pause_before_teardown then yield until
				#the continue button is pressed.
				if(_pause_before_teardown and !_ignore_pause_before_teardown):
					_gui.pause()
					await _wait_for_continue_button().SIGNAL_STOP_YIELD_BEFORE_TEARDOWN

				test_script.clear_signal_watcher()

				# call each post-each-test method until teardown is removed.
				_call_deprecated_script_method(test_script, 'teardown', 'after_each')
				test_script.after_each()

				if(_current_test.passed):
					_gui.get_text_box().add_keyword_color(_current_test.name, Color(0, 1, 0))
				else:
					_gui.get_text_box().add_keyword_color(_current_test.name, Color(1, 0, 0))

				_gui.set_progress_test_value(i + 1)
				_doubler.get_ignored_methods().clear()

		# call both post-all-tests methods until postrun_teardown is removed.
		if(_does_class_name_match(_inner_class_name, the_script.inner_class_name)):
			_call_deprecated_script_method(test_script, 'postrun_teardown', 'after_all')
			test_script.after_all()

		# This might end up being very resource intensive if the scripts
		# don't clean up after themselves.  Might have to consolidate output
		# into some other structure and kill the script objects with
		# test_script.free() instead of remove child.
		remove_child(test_script)
		#END TESTS IN SCRIPT LOOP
		_current_test = null
		_gui.set_progress_script_value(test_indexes + 1) # new way
		#END TEST SCRIPT LOOP

	_end_run()

func _pass(text=''):
	_gui.add_passing()
	if(_current_test):
		_new_summary.add_pass(_current_test.name, text)

func _fail(text=''):
	_gui.add_failing()
	if(_current_test != null):
		var line_text = '  at line ' + str(_extractLineNumber( _current_test))
		p(line_text, LOG_LEVEL_FAIL_ONLY)
		# format for summary
		line_text =  "\n    " + line_text

		_new_summary.add_fail(_current_test.name, text + line_text)
		_current_test.passed = false

# Extracts the line number from curren stacktrace by matching the test case name
func _extractLineNumber(current_test):
	var line_number = current_test.line_number
	# if stack trace available than extraxt the test case line number
	var stackTrace = get_stack()
	if(stackTrace!=null):
		for index in stackTrace.size():
			var line = stackTrace[index]
			var function = line.get("function")
			if function == current_test.name:
				line_number = line.get("line")
	return line_number

func _pending(text=''):
	if(_current_test):
		_new_summary.add_pending(_current_test.name, text)

# Gets all the files in a directory and all subdirectories if get_include_subdirectories
# is true.  The files returned are all sorted by name.
func _get_files(path, prefix, suffix):
	var files = []
	var directories = []

	var d = DirAccess.new()
	d.open(path)
	# true parameter tells list_dir_begin not to include "." and ".." directories.
	d.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547

	# Traversing a directory is kinda odd.  You have to start the process of listing
	# the contents of a directory with list_dir_begin then use get_next until it
	# returns an empty string.  Then I guess you should end it.
	var fs_item = d.get_next()
	var full_path = ''
	while(fs_item != ''):
		full_path = path.plus_file(fs_item)

		#file_exists returns fasle for directories
		if(d.file_exists(full_path)):
			if(fs_item.begins_with(prefix) and fs_item.ends_with(suffix)):
				files.append(full_path)
		elif(get_include_subdirectories() and d.dir_exists(full_path)):
			directories.append(full_path)

		fs_item = d.get_next()
	d.list_dir_end()

	for dir in range(directories.size()):
		var dir_files = _get_files(directories[dir], prefix, suffix)
		for i in range(dir_files.size()):
			files.append(dir_files[i])

	files.sort()
	return files
#########################
#
# public
#
#########################

# ------------------------------------------------------------------------------
# Conditionally prints the text to the console/results variable based on the
# current log level and what level is passed in.  Whenever currently in a test,
# the text will be indented under the test.  It can be further indented if
# desired.
# ------------------------------------------------------------------------------
func p(text, level=0, indent=0):
	var str_text = str(text)
	var to_print = ""
	var printing_test_name = false

	if(level <= _utils.nvl(_log_level, 0)):
		if(_current_test != null):
			#make sure everything printed during the execution
			#of a test is at least indented once under the test
			if(indent == 0):
				indent = 1

			#Print the name of the current test if we haven't
			#printed it already.
			if(!_current_test.has_printed_name):
				to_print = "* " + _current_test.name
				_current_test.has_printed_name = true
				printing_test_name = str_text == _current_test.name

		if(!printing_test_name):
			if(to_print != ""):
				to_print += "\n"
			#Make the indent
			var pad = ""
			for i in range(0, indent):
				pad += "    "
			to_print += pad + str_text
			to_print = to_print.replace("\n", "\n" + pad)

		if(_should_print_to_console):
			print(to_print)

		_log_text += to_print + "\n"

		_gui.get_text_box().insert_text_at_cursor(to_print + "\n")

################
#
# RUN TESTS/ADD SCRIPTS
#
################
func get_minimum_size():
	return Vector2(810, 380)

# ------------------------------------------------------------------------------
# Runs all the scripts that were added using add_script
# ------------------------------------------------------------------------------
func test_scripts(run_rest=false):
	clear_text()

	if(_script_name != null and _script_name != ''):
		var indexes = _get_indexes_matching_script_name(_script_name)
		if(indexes == []):
			_lgr.error('Could not find script matching ' + _script_name)
		else:
			_test_the_scripts(indexes)
	else:
		_test_the_scripts([])


# ------------------------------------------------------------------------------
# Runs a single script passed in.
# ------------------------------------------------------------------------------
func test_script(script):
	_test_collector.set_test_class_prefix(_inner_class_prefix)
	_test_collector.clear()
	_test_collector.add_script(script)
	_test_the_scripts()

# ------------------------------------------------------------------------------
# Adds a script to be run when test_scripts called
#
# No longer supports selecting a script via this method.
# ------------------------------------------------------------------------------
func add_script(script, was_select_this_one=null):
	if(was_select_this_one != null):
		_lgr.error('The option to select a script when using add_script has been removed.  Calling add_script with 2 parameters will be removed in a later release.')

	if(!Engine.is_editor_hint()):
		_test_collector.set_test_class_prefix(_inner_class_prefix)
		_test_collector.add_script(script)
		_add_scripts_to_gui()

# ------------------------------------------------------------------------------
# Add all scripts in the specified directory that start with the prefix and end
# with the suffix.  Does not look in sub directories.  Can be called multiple
# times.
# ------------------------------------------------------------------------------
func add_directory(path, prefix=_file_prefix, suffix=_file_extension):
	var d = DirAccess.new()
	# check for '' b/c the calls to addin the exported directories 1-6 will pass
	# '' if the field has not been populated.  This will cause res:// to be
	# processed which will include all files if include_subdirectories is true.
	if(path == '' or !d.dir_exists(path)):
		if(path != ''):
			_lgr.error(str('The path [', path, '] does not exist.'))
		return

	var files = _get_files(path, prefix, suffix)
	for i in range(files.size()):
		add_script(files[i])

# ------------------------------------------------------------------------------
# This will try to find a script in the list of scripts to test that contains
# the specified script name.  It does not have to be a full match.  It will
# select the first matching occurrence so that this script will run when run_tests
# is called.  Works the same as the select_this_one option of add_script.
#
# returns whether it found a match or not
# ------------------------------------------------------------------------------
func select_script(script_name):
	_script_name = script_name

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func export_tests(path=_export_path):
	if(path == null):
		_lgr.error('You must pass a path or set the export_path before calling export_tests')
	else:
		var result = _test_collector.export_tests(path)
		if(result):
			p(_test_collector.to_s())
			p("Exported to " + path)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func import_tests(path=_export_path):
	if(!_utils.file_exists(path)):
		_lgr.error(str('Cannot import tests:  the path [', path, '] does not exist.'))
	else:
		_test_collector.clear()
		var result = _test_collector.import_tests(path)
		if(result):
			p(_test_collector.to_s())
			p("Imported from " + path)
			_add_scripts_to_gui()

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func import_tests_if_none_found():
	if(_test_collector.scripts.size() == 0):
		import_tests()

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func export_if_tests_found():
	if(_test_collector.scripts.size() > 0):
		export_tests()
################
#
# MISC
#
################

# ------------------------------------------------------------------------------
# Maximize test runner window to fit the viewport.
# ------------------------------------------------------------------------------
func set_should_maximize(should):
	_should_maximize = should

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_should_maximize():
	return _should_maximize

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func maximize():
	_gui.maximize()

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func disable_strict_datatype_checks(should):
	_disable_strict_datatype_checks = should

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func is_strict_datatype_checks_disabled():
	return _disable_strict_datatype_checks

# ------------------------------------------------------------------------------
# Pauses the test and waits for you to press a confirmation button.  Useful when
# you want to watch a test play out onscreen or inspect results.
# ------------------------------------------------------------------------------
func end_yielded_test():
	_lgr.deprecated('end_yielded_test is no longer necessary, you can remove it.')

# ------------------------------------------------------------------------------
# Clears the text of the text box.  This resets all counters.
# ------------------------------------------------------------------------------
func clear_text():
	_gui.get_text_box().set_text("")
	_gui.get_text_box().clear_colors()
	update()

# ------------------------------------------------------------------------------
# Get the number of tests that were ran
# ------------------------------------------------------------------------------
func get_test_count():
	return _new_summary.get_totals().tests

# ------------------------------------------------------------------------------
# Get the number of assertions that were made
# ------------------------------------------------------------------------------
func get_assert_count():
	var t = _new_summary.get_totals()
	return t.passing + t.failing

# ------------------------------------------------------------------------------
# Get the number of assertions that passed
# ------------------------------------------------------------------------------
func get_pass_count():
	return _new_summary.get_totals().passing

# ------------------------------------------------------------------------------
# Get the number of assertions that failed
# ------------------------------------------------------------------------------
func get_fail_count():
	return _new_summary.get_totals().failing

# ------------------------------------------------------------------------------
# Get the number of tests flagged as pending
# ------------------------------------------------------------------------------
func get_pending_count():
	return _new_summary.get_totals().pending

# ------------------------------------------------------------------------------
# Set whether it should print to console or not.  Default is yes.
# ------------------------------------------------------------------------------
func set_should_print_to_console(should):
	_should_print_to_console = should

# ------------------------------------------------------------------------------
# Get whether it is printing to the console
# ------------------------------------------------------------------------------
func get_should_print_to_console():
	return _should_print_to_console

# ------------------------------------------------------------------------------
# Get the results of all tests ran as text.  This string is the same as is
# displayed in the text box, and similar to what is printed to the console.
# ------------------------------------------------------------------------------
func get_result_text():
	return _log_text

# ------------------------------------------------------------------------------
# Set the log level.  Use one of the various LOG_LEVEL_* constants.
# ------------------------------------------------------------------------------
func set_log_level(level):
	_log_level = level
	if(!Engine.is_editor_hint()):
		_gui.set_log_level(level)

# ------------------------------------------------------------------------------
# Get the current log level.
# ------------------------------------------------------------------------------
func get_log_level():
	return _log_level

# ------------------------------------------------------------------------------
# Call this method to make the test pause before teardown so that you can inspect
# anything that you have rendered to the screen.
# ------------------------------------------------------------------------------
func pause_before_teardown():
	_pause_before_teardown = true;

# ------------------------------------------------------------------------------
# For batch processing purposes, you may want to ignore any calls to
# pause_before_teardown that you forgot to remove.
# ------------------------------------------------------------------------------
func set_ignore_pause_before_teardown(should_ignore):
	_ignore_pause_before_teardown = should_ignore
	_gui.set_ignore_pause(should_ignore)

func get_ignore_pause_before_teardown():
	return _ignore_pause_before_teardown

# ------------------------------------------------------------------------------
# Set to true so that painting of the screen will occur between tests.  Allows you
# to see the output as tests occur.  Especially useful with long running tests that
# make it appear as though it has humg.
#
# NOTE:  not compatible with 1.0 so this is disabled by default.  This will
# change in future releases.
# ------------------------------------------------------------------------------
func set_yield_between_tests(should):
	_yield_between.should = should

func get_yield_between_tests():
	return _yield_between.should

# ------------------------------------------------------------------------------
# Call _process or _fixed_process, if they exist, on obj and all it's children
# and their children and so and so forth.  Delta will be passed through to all
# the _process or _fixed_process methods.
# ------------------------------------------------------------------------------
func simulate(obj, times, delta):
	for i in range(times):
		if(obj.has_method("_process")):
			obj._process(delta)
		if(obj.has_method("_physics_process")):
			obj._physics_process(delta)

		for kid in obj.get_children():
			simulate(kid, 1, delta)

# ------------------------------------------------------------------------------
# Starts an internal timer with a timeout of the passed in time.  A 'timeout'
# signal will be sent when the timer ends.  Returns itself so that it can be
# used in a call to yield...cutting down on lines of code.
#
# Example, yield to the Gut object for 10 seconds:
#  yield(gut.set_yield_time(10), 'timeout')
# ------------------------------------------------------------------------------
func set_yield_time(time, text=''):
	_yield_timer.set_wait_time(time)
	_yield_timer.start()
	var msg = '/# Yielding (' + str(time) + 's)'
	if(text == ''):
		msg += ' #/'
	else:
		msg +=  ':  ' + text + ' #/'
	p(msg, 1)
	_was_yield_method_called = true
	return self

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_yield_signal_or_time(obj, signal_name, max_wait, text=''):
	obj.connect(signal_name, Callable(self, '_yielding_callback').bind(true))
	_yielding_to.obj = obj
	_yielding_to.signal_name = signal_name

	_yield_timer.set_wait_time(max_wait)
	_yield_timer.start()
	_was_yield_method_called = true
	p(str('/# Yielding to signal "', signal_name, '" or for ', max_wait, ' seconds #/'))
	return self

# ------------------------------------------------------------------------------
# get the specific unit test that should be run
# ------------------------------------------------------------------------------
func get_unit_test_name():
	return _unit_test_name

# ------------------------------------------------------------------------------
# set the specific unit test that should be run.
# ------------------------------------------------------------------------------
func set_unit_test_name(test_name):
	_unit_test_name = test_name

# ------------------------------------------------------------------------------
# Creates an empty file at the specified path
# ------------------------------------------------------------------------------
func file_touch(path):
	var f = File.new()
	f.open(path, f.WRITE)
	f.close()

# ------------------------------------------------------------------------------
# deletes the file at the specified path
# ------------------------------------------------------------------------------
func file_delete(path):
	var d = DirAccess.new()
	var result = d.open(path.get_base_dir())
	if(result == OK):
		d.remove(path)

# ------------------------------------------------------------------------------
# Checks to see if the passed in file has any data in it.
# ------------------------------------------------------------------------------
func is_file_empty(path):
	var f = File.new()
	f.open(path, f.READ)
	var empty = f.get_length() == 0
	f.close()
	return empty

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_file_as_text(path):
	var to_return = ''
	var f = File.new()
	f.open(path, f.READ)
	to_return = f.get_as_text()
	f.close()
	return to_return
# ------------------------------------------------------------------------------
# deletes all files in a given directory
# ------------------------------------------------------------------------------
func directory_delete_files(path):
	var d = DirAccess.new()
	var result = d.open(path)

	# SHORTCIRCUIT
	if(result != OK):
		return

	# Traversing a directory is kinda odd.  You have to start the process of listing
	# the contents of a directory with list_dir_begin then use get_next until it
	# returns an empty string.  Then I guess you should end it.
	d.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var thing = d.get_next() # could be a dir or a file or something else maybe?
	var full_path = ''
	while(thing != ''):
		full_path = path + "/" + thing
		#file_exists returns fasle for directories
		if(d.file_exists(full_path)):
			d.remove(full_path)
		thing = d.get_next()
	d.list_dir_end()

# ------------------------------------------------------------------------------
# Returns the instantiated script object that is currently being run.
# ------------------------------------------------------------------------------
func get_current_script_object():
	var to_return = null
	if(_test_script_objects.size() > 0):
		to_return = _test_script_objects[-1]
	return to_return

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_current_test_object():
	return _current_test

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_stubber():
	return _stubber

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_doubler():
	return _doubler

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_spy():
	return _spy

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_temp_directory():
	return _temp_directory

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_temp_directory(temp_directory):
	_temp_directory = temp_directory

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_inner_class_name():
	return _inner_class_name

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_inner_class_name(inner_class_name):
	_inner_class_name = inner_class_name

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_summary():
	return _new_summary

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_double_strategy():
	return _double_strategy

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_double_strategy(double_strategy):
	_double_strategy = double_strategy
	_doubler.set_strategy(double_strategy)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_include_subdirectories():
	return _include_subdirectories

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_logger():
	return _lgr

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_logger(logger):
	_lgr = logger

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_include_subdirectories(include_subdirectories):
	_include_subdirectories = include_subdirectories

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_test_collector():
	return _test_collector

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_export_path():
	return _export_path

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_export_path(export_path):
	_export_path = export_path

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_version():
	return _version

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_pre_run_script():
	return _pre_run_script

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_pre_run_script(pre_run_script):
	_pre_run_script = pre_run_script

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_post_run_script():
	return _post_run_script

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func set_post_run_script(post_run_script):
	_post_run_script = post_run_script

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_pre_run_script_instance():
	return _pre_run_script_instance

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func get_post_run_script_instance():
	return _post_run_script_instance
       extends Panel

@onready var _script_list = $ScriptsList
@onready var _nav = {
	prev = $Navigation/Previous,
	next = $Navigation/Next,
	run = $Navigation/Run,
	current_script = $Navigation/CurrentScript,
	show_scripts = $Navigation/ShowScripts
}
@onready var _progress = {
	script = $ScriptProgress,
	test = $TestProgress
}
@onready var _summary = {
	failing = $Summary/Failing,
	passing = $Summary/Passing
}

@onready var _extras = $ExtraOptions
@onready var _ignore_pauses = $ExtraOptions/IgnorePause
@onready var _continue_button = $Continue/Continue
@onready var _text_box = $TextDisplay/RichTextLabel

@onready var _titlebar = {
	bar = $TitleBar,
	time = $TitleBar/Time,
	label = $TitleBar/Title
}

var _mouse = {
	down = false,
	in_title = false,
	down_pos = null,
	in_handle = false
}
var _is_running = false
var _start_time = 0.0
var _time = 0.0

const DEFAULT_TITLE = 'Gut: The Godot Unit Testing tool.'
var _utils = load('res://addons/gut/utils.gd').new()
var _text_box_blocker_enabled = true
var _pre_maximize_size = null

signal end_pause
signal ignore_pause
signal log_level_changed
signal run_script
signal run_single_script
signal script_selected

func _ready():
	_pre_maximize_size = size
	_hide_scripts()
	_update_controls()
	_nav.current_script.set_text("No scripts available")
	set_title()
	clear_summary()
	$TitleBar/Time.set_text("")
	$ExtraOptions/DisableBlocker.button_pressed = !_text_box_blocker_enabled
	_extras.visible = false
	update()

func _process(delta):
	if(_is_running):
		_time = Time.get_unix_time_from_system() - _start_time
		var disp_time = round(_time * 100)/100
		$TitleBar/Time.set_text(str(disp_time))

func _draw(): # needs get_size()
	# Draw the lines in the corner to show where you can
	# drag to resize the dialog
	var grab_margin = 3
	var line_space = 3
	var grab_line_color = Color(.4, .4, .4)
	for i in range(1, 10):
		var x = size - Vector2(i * line_space, grab_margin)
		var y = size - Vector2(grab_margin, i * line_space)
		draw_line(x, y, grab_line_color, 1)

func _on_Maximize_draw():
	# draw the maximize square thing.
	var btn = $TitleBar/Maximize
	btn.set_text('')
	var w = btn.get_size().x
	var h = btn.get_size().y
	btn.draw_rect(Rect2(0, 0, w, h), Color(0, 0, 0, 1))
	btn.draw_rect(Rect2(2, 4, w - 4, h - 6), Color(1,1,1,1))

func _on_ShowExtras_draw():
	var btn = $Continue/ShowExtras
	btn.set_text('')
	var start_x = 20
	var start_y = 15
	var pad = 5
	var color = Color(.1, .1, .1, 1)
	var width = 2
	for i in range(3):
		var y = start_y + pad * i
		btn.draw_line(Vector2(start_x, y), Vector2(btn.get_size().x - start_x, y), color, width)

# ####################
# GUI Events
# ####################
func _on_Run_pressed():
	_run_mode()
	emit_signal('run_script', get_selected_index())

func _on_CurrentScript_pressed():
	_run_mode()
	emit_signal('run_single_script', get_selected_index())

func _on_Previous_pressed():
	_select_script(get_selected_index() - 1)

func _on_Next_pressed():
	_select_script(get_selected_index() + 1)

func _on_LogLevelSlider_value_changed(value):
	emit_signal('log_level_changed', $LogLevelSlider.value)

func _on_Continue_pressed():
	_continue_button.disabled = true
	emit_signal('end_pause')

func _on_IgnorePause_pressed():
	var checked = _ignore_pauses.is_pressed()
	emit_signal('ignore_pause', checked)
	if(checked):
		emit_signal('end_pause')
		_continue_button.disabled = true

func _on_ShowScripts_pressed():
	_toggle_scripts()

func _on_ScriptsList_item_selected(index):
	_select_script(index)

func _on_TitleBar_mouse_entered():
	_mouse.in_title = true

func _on_TitleBar_mouse_exited():
	_mouse.in_title = false

func _input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			_mouse.down = event.pressed
			if(_mouse.down):
				_mouse.down_pos = event.position

	if(_mouse.in_title):
		if(event is InputEventMouseMotion and _mouse.down):
			set_position(get_position() + (event.position - _mouse.down_pos))
			_mouse.down_pos = event.position

	if(_mouse.in_handle):
		if(event is InputEventMouseMotion and _mouse.down):
			var new_size = size + event.position - _mouse.down_pos
			var new_mouse_down_pos = event.position
			size = new_size
			_mouse.down_pos = new_mouse_down_pos
			_pre_maximize_size = size

func _on_ResizeHandle_mouse_entered():
	_mouse.in_handle = true

func _on_ResizeHandle_mouse_exited():
	_mouse.in_handle = false

# Send scroll type events through to the text box
func _on_FocusBlocker_gui_input(ev):
	if(_text_box_blocker_enabled):
		if(ev is InputEventPanGesture):
			get_text_box()._gui_input(ev)
		# convert a drag into a pan gesture so it scrolls.
		elif(ev is InputEventScreenDrag):
			var converted = InputEventPanGesture.new()
			converted.delta = Vector2(0, ev.relative.y)
			converted.position = Vector2(0, 0)
			get_text_box()._gui_input(converted)
		elif(ev is InputEventMouseButton and (ev.button_index == MOUSE_BUTTON_WHEEL_DOWN or ev.button_index == MOUSE_BUTTON_WHEEL_UP)):
			get_text_box()._gui_input(ev)
	else:
		get_text_box()._gui_input(ev)
		print(ev)

func _on_RichTextLabel_gui_input(ev):
	pass
	# leaving this b/c it is wired up and might have to send
	# more signals through
	print(ev)

func _on_Copy_pressed():
	_text_box.select_all()
	_text_box.copy()
	_text_box.deselect()

func _on_DisableBlocker_toggled(button_pressed):
	_text_box_blocker_enabled = !button_pressed

func _on_ShowExtras_toggled(button_pressed):
	_extras.visible = button_pressed

func _on_Maximize_pressed():
	if(size == _pre_maximize_size):
		maximize()
	else:
		size = _pre_maximize_size
# ####################
# Private
# ####################
func _run_mode(is_running=true):
	if(is_running):
		_start_time = Time.get_unix_time_from_system()
		_time = _start_time
		_summary.failing.set_text("0")
		_summary.passing.set_text("0")
	_is_running = is_running

	_hide_scripts()
	var ctrls = $Navigation.get_children()
	for i in range(ctrls.size()):
		ctrls[i].disabled = is_running

func _select_script(index):
	$Navigation/CurrentScript.set_text(_script_list.get_item_text(index))
	_script_list.select(index)
	_update_controls()

func _toggle_scripts():
	if(_script_list.visible):
		_hide_scripts()
	else:
		_show_scripts()

func _show_scripts():
	_script_list.show()

func _hide_scripts():
	_script_list.hide()

func _update_controls():
	var is_empty = _script_list.get_selected_items().size() == 0
	if(is_empty):
		_nav.next.disabled = true
		_nav.prev.disabled = true
	else:
		var index = get_selected_index()
		_nav.prev.disabled = index <= 0
		_nav.next.disabled = index >= _script_list.get_item_count() - 1

	_nav.run.disabled = is_empty
	_nav.current_script.disabled = is_empty
	_nav.show_scripts.disabled = is_empty


# ####################
# Public
# ####################
func run_mode(is_running=true):
	_run_mode(is_running)

func set_scripts(scripts):
	_script_list.clear()
	for i in range(scripts.size()):
		_script_list.add_item(scripts[i])
	_select_script(0)
	_update_controls()

func select_script(index):
	_select_script(index)

func get_selected_index():
	return _script_list.get_selected_items()[0]

func get_log_level():
	return $LogLevelSlider.value

func set_log_level(value):
	$LogLevelSlider.value = _utils.nvl(value, 0)

func set_ignore_pause(should):
	_ignore_pauses.button_pressed = should

func get_ignore_pause():
	return _ignore_pauses.pressed

func get_text_box():
	return $TextDisplay/RichTextLabel

func end_run():
	_run_mode(false)
	_update_controls()

func set_progress_script_max(value):
	_progress.script.set_max(value)

func set_progress_script_value(value):
	_progress.script.set_value(value)

func set_progress_test_max(value):
	_progress.test.set_max(value)

func set_progress_test_value(value):
	_progress.test.set_value(value)

func clear_progress():
	_progress.test.set_value(0)
	_progress.script.set_value(0)

func pause():
	print('we got here')
	_continue_button.disabled = false

func set_title(title=null):
	if(title == null):
		$TitleBar/Title.set_text(DEFAULT_TITLE)
	else:
		$TitleBar/Title.set_text(title)

func get_run_duration():
	return $TitleBar/Time.text.to_float()

func add_passing(amount=1):
	if(!_summary):
		return
	_summary.passing.set_text(str(_summary.passing.get_text().to_int() + amount))
	$Summary.show()

func add_failing(amount=1):
	if(!_summary):
		return
	_summary.failing.set_text(str(_summary.failing.get_text().to_int() + amount))
	$Summary.show()

func clear_summary():
	_summary.passing.set_text("0")
	_summary.failing.set_text("0")
	$Summary.hide()

func maximize():
	if(is_inside_tree()):
		var vp_size_offset = get_viewport().size
		size = vp_size_offset / get_scale()
		set_position(Vector2(0, 0))

    RSRC                    PackedScene            ��������                                            %      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Panel/styles/panel    Panel/styles/panelf    Panel/styles/panelnc 	   _bundled       Script    res://addons/gut/GutScene.gd ��������   
   local://1 *      
   local://2 w         local://Theme_t1c5k �         local://PackedScene_7wbuu &         StyleBoxFlat          �F>�nR> \>  �?                           StyleBoxFlat            �?  �?  �?  �?                    �?                           Theme              !            "          #                   PackedScene    $      	         names "   a      Gut    custom_minimum_size    offset_right    offset_bottom    theme_override_styles/panel    script    Panel 	   TitleBar    layout_mode    anchor_right    theme    Title !   theme_override_colors/font_color    text    Label    Time    anchor_left    offset_left 	   Maximize    offset_top    flat    Button    ScriptProgress    anchor_top    anchor_bottom    step    ProgressBar    TestProgress    TextDisplay    RichTextLabel    mouse_default_cursor_shape 	   TextEdit    FocusBlocker    self_modulate    Navigation 	   Previous    Next    Run    CurrentScript 
   clip_text    ShowScripts    LogLevelSlider    scale 
   max_value    tick_count    ticks_on_borders    HSlider    ScriptsList    allow_reselect 	   ItemList    ExtraOptions    IgnorePause 	   CheckBox    DisableBlocker    Copy    ResizeHandle    anchors_preset    Control 	   Continue 	   disabled    ShowExtras    pivot_offset    toggle_mode    Summary 	   position    Node2D    Passing    Failing    _on_TitleBar_mouse_entered    mouse_entered    _on_TitleBar_mouse_exited    mouse_exited    _on_Maximize_draw    draw    _on_Maximize_pressed    pressed    _on_RichTextLabel_gui_input 
   gui_input    _on_FocusBlocker_gui_input    _on_Previous_pressed    _on_Next_pressed    _on_Run_pressed    _on_CurrentScript_pressed    _on_ShowScripts_pressed !   _on_LogLevelSlider_value_changed    value_changed    _on_ScriptsList_item_selected    item_selected    _on_IgnorePause_pressed    _on_DisableBlocker_toggled    toggled    _on_Copy_pressed    _on_ResizeHandle_mouse_entered    _on_ResizeHandle_mouse_exited    _on_Continue_pressed    _on_ShowExtras_draw    _on_ShowExtras_toggled    	   variants    M   
     9D  zC     9D     �C                                �?      B                          �?      Gut      ��     T�      9999.99      ��      A     ��     �A      M            �B     ��     4C     ��      �     �A      Script       �      Tests      ��     �?  �?  �?         \C     D     HB      <      fC     �C      >      pB      Run      �B      res://test/unit/test_gut.gd      �C      ...      �B     C     ��
      @   @      @           �     �@     �A
      ?   ?   
   Log Level      D     ��     R�     v�     ��      C     B
     �?  �?      Ignore Pauses      �B      Selectable      �A     HC      Copy      �     �B   	   Continue      �B
     B  �A      _ 
         @@      0       node_count              nodes     v  ��������       ����                                                    ����         	            
                       ����         	               	      
                    ����               	                           	                          ����
               	                                 	                                 ����                                                                    ����                                                   ����                                                                    ����                                                   ����         	                            	             ����         	                      	              ����   !            	                                 "   ����   !                                                         #   ����                  !            "                 $   ����            #      $            %                 %   ����            &                  '                 &   ����                  !      $      (      )   '                    (   ����                  !      *      (      +               .   )   ����                        ,            -      .   *   /   +   0   ,   1   -                       ����            2      3      4      4   *   5      6               1   /   ����                              7      8   0                     2   ����	                     	               9      :      ;                    4   3   ����                        <      =   *   >      ?              4   5   ����                  !      -      @   *   >      A                 6   ����            B      (      C      -      D               9   7   ����   8                  	                                       :   ����
   !                        	               E                                   :   ����            !      F      (   ;         G                 <   ����            !      H         =   I   >         J               A   ?   ����   @   K                 B   ����                        	      L                 C   ����                  ,            	      L             conn_count             conns     �          E   D                     G   F                     I   H                     K   J              
       M   L                     M   N                     K   O                     K   P                     K   Q                     K   R                     K   S                     U   T                     W   V                     K   X                     Z   Y                     K   [                     E   \                     G   ]                     K   ^                     I   _                     Z   `                    node_paths              editable_instances              version             RSRC################################################################################
#(G)odot (U)nit (T)est class
#
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################
# Description
# -----------
# Command line interface for the GUT unit testing tool.  Allows you to run tests
# from the command line instead of running a scene.  Place this script along with
# gut.gd into your scripts directory at the root of your project.  Once there you
# can run this script (from the root of your project) using the following command:
# 	godot -s -d test/gut/gut_cmdln.gd
#
# See the readme for a list of options and examples.  You can also use the -gh
# option to get more information about how to use the command line interface.
#
# Version 6.8.1
################################################################################
extends SceneTree


var Optparse = load('res://addons/gut/optparse.gd')
var Gut = load('res://addons/gut/gut.gd')

#-------------------------------------------------------------------------------
# Helper class to resolve the various different places where an option can
# be set.  Using the get_value method will enforce the order of precedence of:
# 	1.  command line value
#	2.  config file value
#	3.  default value
#
# The idea is that you set the base_opts.  That will get you a copies of the
# hash with null values for the other types of values.  Lower precedented hashes
# will punch through null values of higher precedented hashes.
#-------------------------------------------------------------------------------
class OptionResolver:
	var base_opts = null
	var cmd_opts = null
	var config_opts = null


	func get_value(key):
		return _nvl(cmd_opts[key], _nvl(config_opts[key], base_opts[key]))

	func set_base_opts(opts):
		base_opts = opts
		cmd_opts = _null_copy(opts)
		config_opts = _null_copy(opts)

	# creates a copy of a hash with all values null.
	func _null_copy(h):
		var new_hash = {}
		for key in h:
			new_hash[key] = null
		return new_hash

	func _nvl(a, b):
		if(a == null):
			return b
		else:
			return a
	func _string_it(h):
		var to_return = ''
		for key in h:
			to_return += str('(',key, ':', _nvl(h[key], 'NULL'), ')')
		return to_return

	func to_s():
		return str("base:\n", _string_it(base_opts), "\n", \
				   "config:\n", _string_it(config_opts), "\n", \
				   "cmd:\n", _string_it(cmd_opts), "\n", \
				   "resolved:\n", _string_it(get_resolved_values()))

	func get_resolved_values():
		var to_return = {}
		for key in base_opts:
			to_return[key] = get_value(key)
		return to_return

	func to_s_verbose():
		var to_return = ''
		var resolved = get_resolved_values()
		for key in base_opts:
			to_return += str(key, "\n")
			to_return += str('  default: ', _nvl(base_opts[key], 'NULL'), "\n")
			to_return += str('  config:  ', _nvl(config_opts[key], ' --'), "\n")
			to_return += str('  cmd:     ', _nvl(cmd_opts[key], ' --'), "\n")
			to_return += str('  final:   ', _nvl(resolved[key], 'NULL'), "\n")

		return to_return

#-------------------------------------------------------------------------------
# Here starts the actual script that uses the Options class to kick off Gut
# and run your tests.
#-------------------------------------------------------------------------------
var _utils = load('res://addons/gut/utils.gd').new()
# instance of gut
var _tester = null
# array of command line options specified
var _opts = []
# Hash for easier access to the options in the code.  Options will be
# extracted into this hash and then the hash will be used afterwards so
# that I don't make any dumb typos and get the neat code-sense when I
# type a dot.
var options = {
	config_file = 'res://.gutconfig.json',
	dirs = [],
	double_strategy = 'partial',
	ignore_pause = false,
	include_subdirs = false,
	inner_class = '',
	log_level = 1,
	opacity = 100,
	prefix = 'test_',
	selected = '',
	should_exit = false,
	should_exit_on_success = false,
	should_maximize = false,
	show_help = false,
	suffix = '.gd',
	tests = [],
	unit_test_name = '',
	pre_run_script = '',
	post_run_script = ''
}

# flag to indicate if only a single script should be run.
var _run_single = false

func setup_options():
	var opts = Optparse.new()
	opts.set_banner(('This is the command line interface for the unit testing tool Gut.  With this ' +
					'interface you can run one or more test scripts from the command line.  In order ' +
					'for the Gut options to not clash with any other godot options, each option starts ' +
					'with a "g".  Also, any option that requires a value will take the form of ' +
					'"-g<name>=<value>".  There cannot be any spaces between the option, the "=", or ' +
					'inside a specified value or godot will think you are trying to run a scene.'))
	opts.add('-gtest', [], 'Comma delimited list of full paths to test scripts to run.')
	opts.add('-gdir', [], 'Comma delimited list of directories to add tests from.')
	opts.add('-gprefix', 'test_', 'Prefix used to find tests when specifying -gdir.  Default "[default]"')
	opts.add('-gsuffix', '.gd', 'Suffix used to find tests when specifying -gdir.  Default "[default]"')
	opts.add('-gmaximize', false, 'Maximizes test runner window to fit the viewport.')
	opts.add('-gexit', false, 'Exit after running tests.  If not specified you have to manually close the window.')
	opts.add('-gexit_on_success', false, 'Only exit if all tests pass.')
	opts.add('-glog', 1, 'Log level.  Default [default]')
	opts.add('-gignore_pause', false, 'Ignores any calls to gut.pause_before_teardown.')
	opts.add('-gselect', '', ('Select a script to run initially.  The first script that ' +
							'was loaded using -gtest or -gdir that contains the specified ' +
							'string will be executed.  You may run others by interacting ' +
							'with the GUI.'))
	opts.add('-gunit_test_name', '', ('Name of a test to run.  Any test that contains the specified ' +
								'text will be run, all others will be skipped.'))
	opts.add('-gh', false, 'Print this help, then quit')
	opts.add('-gconfig', 'res://.gutconfig.json', 'A config file that contains configuration information.  Default is res://.gutconfig.json')
	opts.add('-ginner_class', '', 'Only run inner classes that contain this string')
	opts.add('-gopacity', 100, 'Set opacity of test runner window. Use range 0 - 100. 0 = transparent, 100 = opaque.')
	opts.add('-gpo', false, 'Print option values from all sources and the value used, then quit.')
	opts.add('-ginclude_subdirs', false, 'Include subdirectories of -gdir.')
	opts.add('-gdouble_strategy', 'partial', 'Default strategy to use when doubling.  Valid values are [partial, full].  Default "[default]"')
	opts.add('-gpre_run_script', '', 'pre-run hook script path')
	opts.add('-gpost_run_script', '', 'post-run hook script path')
	opts.add('-gprint_gutconfig_sample', false, 'Print out json that can be used to make a gutconfig file then quit.')
	return opts


# Parses options, applying them to the _tester or setting values
# in the options struct.
func extract_command_line_options(from, to):
	to.tests = from.get_value('-gtest')
	to.dirs = from.get_value('-gdir')
	to.should_exit = from.get_value('-gexit')
	to.should_exit_on_success = from.get_value('-gexit_on_success')
	to.should_maximize = from.get_value('-gmaximize')
	to.log_level = from.get_value('-glog')
	to.ignore_pause = from.get_value('-gignore_pause')
	to.selected = from.get_value('-gselect')
	to.prefix = from.get_value('-gprefix')
	to.suffix = from.get_value('-gsuffix')
	to.unit_test_name = from.get_value('-gunit_test_name')
	to.config_file = from.get_value('-gconfig')
	to.inner_class = from.get_value('-ginner_class')
	to.opacity = from.get_value('-gopacity')
	to.include_subdirs = from.get_value('-ginclude_subdirs')
	to.double_strategy = from.get_value('-gdouble_strategy')
	to.pre_run_script = from.get_value('-gpre_run_script')
	to.post_run_script = from.get_value('-gpost_run_script')


func load_options_from_config_file(file_path, into):
	# SHORTCIRCUIT
	var f = File.new()
	if(!f.file_exists(file_path)):
		if(file_path != 'res://.gutconfig.json'):
			print('ERROR:  Config File "', file_path, '" does not exist.')
			return -1
		else:
			return 1

	f.open(file_path, f.READ)
	var json = f.get_as_text()
	f.close()

	var test_json_conv = JSON.new()
	test_json_conv.parse(json)
	var results = test_json_conv.get_data()
	# SHORTCIRCUIT
	if(results.error != OK):
		print("\n\n",'!! ERROR parsing file:  ', file_path)
		print('    at line ', results.error_line, ':')
		print('    ', results.error_string)
		return -1

	# Get all the options out of the config file using the option name.  The
	# options hash is now the default source of truth for the name of an option.
	for key in into:
		if(results.result.has(key)):
			into[key] = results.result[key]

	return 1

# Apply all the options specified to _tester.  This is where the rubber meets
# the road.
func apply_options(opts):
	_tester = Gut.new()
	get_root().add_child(_tester)
	_tester.connect('tests_finished', Callable(self, '_on_tests_finished').bind(opts.should_exit, opts.should_exit_on_success))
	_tester.set_yield_between_tests(true)
	_tester.set_modulate(Color(1.0, 1.0, 1.0, min(1.0, float(opts.opacity) / 100)))
	_tester.show()

	_tester.set_include_subdirectories(opts.include_subdirs)

	if(opts.should_maximize):
		_tester.maximize()

	if(opts.inner_class != ''):
		_tester.set_inner_class_name(opts.inner_class)
	_tester.set_log_level(opts.log_level)
	_tester.set_ignore_pause_before_teardown(opts.ignore_pause)

	for i in range(opts.dirs.size()):
		_tester.add_directory(opts.dirs[i], opts.prefix, opts.suffix)

	for i in range(opts.tests.size()):
		_tester.add_script(opts.tests[i])

	if(opts.selected != ''):
		_tester.select_script(opts.selected)
		_run_single = true

	if(opts.double_strategy == 'full'):
		_tester.set_double_strategy(_utils.DOUBLE_STRATEGY.FULL)
	elif(opts.double_strategy == 'partial'):
		_tester.set_double_strategy(_utils.DOUBLE_STRATEGY.PARTIAL)

	_tester.set_unit_test_name(opts.unit_test_name)
	_tester.set_pre_run_script(opts.pre_run_script)
	_tester.set_post_run_script(opts.post_run_script)

func _print_gutconfigs(values):
	var header = """Here is a sample of a full .gutconfig.json file.
You do not need to specify all values in your own file.  The values supplied in
this sample are what would be used if you ran gut w/o the -gprint_gutconfig_sample
option (the resolved values where default < super.gutconfig < command line)."""
	print("\n", header.replace("\n", ' '), "\n\n")
	var resolved = values

	# remove some options that don't make sense to be in config
	resolved.erase("config_file")
	resolved.erase("show_help")

	print("Here's a config with all the properties set based off of your current command and config.")
	var text = JSON.stringify(resolved)
	print(text.replace(',', ",\n"))

	for key in resolved:
		resolved[key] = null

	print("\n\nAnd here's an empty config for you fill in what you want.")
	text = JSON.stringify(resolved)
	print(text.replace(',', ",\n"))


# parse options and run Gut
func _init():
	var opt_resolver = OptionResolver.new()
	opt_resolver.set_base_opts(options)

	print("\n\n", ' ---  Gut  ---')
	var o = setup_options()

	var all_options_valid = o.parse()
	extract_command_line_options(o, opt_resolver.cmd_opts)
	var load_result = \
			load_options_from_config_file(opt_resolver.get_value('config_file'), opt_resolver.config_opts)

	if(load_result == -1): # -1 indicates json parse error
		quit()
	else:
		if(!all_options_valid):
			quit()
		elif(o.get_value('-gh')):
			var v_info = Engine.get_version_info()
			print(str('Godot version:  ', v_info.major,  '.',  v_info.minor,  '.',  v_info.patch))
			print(str('GUT version:  ', Gut.new().get_version()))

			o.print_help()
			quit()
		elif(o.get_value('-gpo')):
			print('All command line options and where they are specified.  ' +
				'The "final" value shows which value will actually be used ' +
				'based on order of precedence (default < super.gutconfig < cmd line).' + "\n")
			print(opt_resolver.to_s_verbose())
			quit()
		elif(o.get_value('-gprint_gutconfig_sample')):
			_print_gutconfigs(opt_resolver.get_resolved_values())
			quit()
		else:
			apply_options(opt_resolver.get_resolved_values())
			_tester.test_scripts(!_run_single)

# exit if option is set.
func _on_tests_finished(should_exit, should_exit_on_success):
	if(_tester.get_fail_count()):
		OS.exit_code = 1

	# Overwrite the exit code with the post_script
	var post_inst = _tester.get_post_run_script_instance()
	if(post_inst != null and post_inst.get_exit_code() != null):
		OS.exit_code = post_inst.get_exit_code()

	if(should_exit or (should_exit_on_success and _tester.get_fail_count() == 0)):
		quit()
	else:
		print("Tests finished, exit manually")
 @tool
extends EditorPlugin

func _enter_tree():
    # Initialization of the plugin goes here
    # Add the new type with a name, a parent type, a script and an icon
    add_custom_type("Gut", "Control", preload("gut.gd"), preload("icon.png"))

func _exit_tree():
    # Clean-up of the plugin goes here
    # Always remember to remove it from the engine when deactivated
    remove_custom_type("Gut")
# ------------------------------------------------------------------------------
# This script is the base for custom scripts to be used in pre and post
# run hooks.
# ------------------------------------------------------------------------------

# This is the instance of GUT that is running the tests.  You can get
# information about the run from this object.  This is set by GUT when the
# script is instantiated.
var gut  = null

# the exit code to be used by gut_cmdln.  See set method.
var _exit_code = null

var _should_abort =  false
# Virtual method that will be called by GUT after instantiating
# this script.
func run():
	pass

# Set the exit code when running from the command line.  If not set then the
# default exit code will be returned (0 when no tests fail, 1 when any tests
# fail).
func set_exit_code(code):
	_exit_code  = code

func get_exit_code():
	return _exit_code

# Usable by pre-run script to cause the run to end AFTER the run() method
# finishes.  post-run script will not be ran.
func abort():
	_should_abort = true

func should_abort():
	return _should_abort
          GST2            ����                        b   RIFFZ   WEBPVP8LN   /� �M����$�{L��@ ɟe�E���CP�HR��v~h�M>�0�ACD�'�|S�h���j�hA�KS���      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bffidopdaeqwv"
path="res://.godot/imported/icon.png-91b084043b8aaf2f1c906e7b9fa92969.ctex"
metadata={
"vram_texture": false
}
                extends Node2D

var _gut = null

var types = {
	warn = 'WARNING',
	error = 'ERROR',
	info = 'INFO',
	debug = 'DEBUG',
	deprecated = 'DEPRECATED'
}

var _logs = {
	types.warn: [],
	types.error: [],
	types.info: [],
	types.debug: [],
	types.deprecated: []
}

var _suppress_output = false

func _gut_log_level_for_type(log_type):
	if(log_type == types.warn or log_type == types.error or log_type == types.deprecated):
		return 0
	else:
		return 2

func _log(type, text):
	_logs[type].append(text)
	var formatted = str('[', type, ']  ', text)
	if(!_suppress_output):
		if(_gut):
			# this will keep the text indented under test for readability
			_gut.p(formatted, _gut_log_level_for_type(type))
			# IDEA!  We could store the current script and test that generated
			# this output, which could be useful later if we printed out a summary.
		else:
			print(formatted)
	return formatted

# ---------------
# Get Methods
# ---------------
func get_warnings():
	return get_log_entries(types.warn)

func get_errors():
	return get_log_entries(types.error)

func get_infos():
	return get_log_entries(types.info)

func get_debugs():
	return get_log_entries(types.debug)

func get_deprecated():
	return get_log_entries(types.deprecated)

func get_count(log_type=null):
	var count = 0
	if(log_type == null):
		for key in _logs:
			count += _logs[key].size()
	else:
		count = _logs[log_type].size()
	return count

func get_log_entries(log_type):
	return _logs[log_type]

# ---------------
# Log methods
# ---------------
func warn(text):
	return _log(types.warn, text)

func error(text):
	return _log(types.error, text)

func info(text):
	return _log(types.info, text)

func debug(text):
	return _log(types.debug, text)

# supply some text or the name of the deprecated method and the replacement.
func deprecated(text, alt_method=null):
	var msg = text
	if(alt_method):
		msg = str('The method ', text, ' is deprecated, use ', alt_method , ' instead.')
	return _log(types.deprecated, msg)

# ---------------
# Misc
# ---------------
func get_gut():
	return _gut

func set_gut(gut):
	_gut = gut

func clear():
	for key in _logs:
		_logs[key].clear()
       # This class will generate method declaration lines based on method meta
# data.  It will create defaults that match the method data.
#
# --------------------
# function meta data
# --------------------
# name:
# flags:
# args: [{
# 	(class_name:),
# 	(hint:0),
# 	(hint_string:),
# 	(name:),
# 	(type:4),
# 	(usage:7)
# }]
# default_args []

var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()
const PARAM_PREFIX = 'p_'

# ------------------------------------------------------
# _supported_defaults
#
# This array contains all the data types that are supported for default values.
# If a value is supported it will contain either an empty string or a prefix
# that should be used when setting the parameter default value.
# For example int, real, bool do not need anything func(p1=1, p2=2.2, p3=false)
# but things like Vectors and Colors do since only the parameters to create a
# new Vector or Color are included in the metadata.
# ------------------------------------------------------
	# TYPE_NIL = 0 — Variable is of type nil (only applied for null).
	# TYPE_BOOL = 1 — Variable is of type bool.
	# TYPE_INT = 2 — Variable is of type int.
	# TYPE_REAL = 3 — Variable is of type float/real.
	# TYPE_STRING = 4 — Variable is of type String.
	# TYPE_VECTOR2 = 5 — Variable is of type Vector2.
	# TYPE_RECT2 = 6 — Variable is of type Rect2.
	# TYPE_VECTOR3 = 7 — Variable is of type Vector3.
	# TYPE_COLOR = 14 — Variable is of type Color.
	# TYPE_OBJECT = 17 — Variable is of type Object.
	# TYPE_DICTIONARY = 18 — Variable is of type Dictionary.
	# TYPE_ARRAY = 19 — Variable is of type Array.
	# TYPE_VECTOR2_ARRAY = 24 — Variable is of type PoolVector2Array.



# TYPE_TRANSFORM2D = 8 — Variable is of type Transform2D.
# TYPE_PLANE = 9 — Variable is of type Plane.
# TYPE_QUAT = 10 — Variable is of type Quat.
# TYPE_AABB = 11 — Variable is of type AABB.
# TYPE_BASIS = 12 — Variable is of type Basis.
# TYPE_TRANSFORM = 13 — Variable is of type Transform.
# TYPE_NODE_PATH = 15 — Variable is of type NodePath.
# TYPE_RID = 16 — Variable is of type RID.
# TYPE_RAW_ARRAY = 20 — Variable is of type PoolByteArray.
# TYPE_INT_ARRAY = 21 — Variable is of type PoolIntArray.
# TYPE_REAL_ARRAY = 22 — Variable is of type PoolRealArray.
# TYPE_STRING_ARRAY = 23 — Variable is of type PoolStringArray.
# TYPE_VECTOR3_ARRAY = 25 — Variable is of type PoolVector3Array.
# TYPE_COLOR_ARRAY = 26 — Variable is of type PoolColorArray.
# TYPE_MAX = 27 — Marker for end of type constants.
# ------------------------------------------------------
var _supported_defaults = []

func _init():
	for i in range(TYPE_MAX):
		_supported_defaults.append(null)

	# These types do not require a prefix for defaults
	_supported_defaults[TYPE_NIL] = ''
	_supported_defaults[TYPE_BOOL] = ''
	_supported_defaults[TYPE_INT] = ''
	_supported_defaults[TYPE_FLOAT] = ''
	_supported_defaults[TYPE_OBJECT] = ''
	_supported_defaults[TYPE_ARRAY] = ''
	_supported_defaults[TYPE_STRING] = ''
	_supported_defaults[TYPE_DICTIONARY] = ''
	_supported_defaults[TYPE_PACKED_VECTOR2_ARRAY] = ''

	# These require a prefix for whatever default is provided
	_supported_defaults[TYPE_VECTOR2] = 'Vector2'
	_supported_defaults[TYPE_RECT2] = 'Rect2'
	_supported_defaults[TYPE_VECTOR3] = 'Vector3'
	_supported_defaults[TYPE_COLOR] = 'Color'

# ###############
# Private
# ###############

func _is_supported_default(type_flag):
	return type_flag >= 0 and type_flag < _supported_defaults.size() and [type_flag] != null

# Creates a list of parameters with defaults of null unless a default value is
# found in the metadata.  If a default is found in the meta then it is used if
# it is one we know how support.
#
# If a default is found that we don't know how to handle then this method will
# return null.
func _get_arg_text(method_meta):
	var text = ''
	var args = method_meta.args
	var defaults = []
	var has_unsupported_defaults = false

	# fill up the defaults with null defaults for everything that doesn't have
	# a default in the meta data.  default_args is an array of default values
	# for the last n parameters where n is the size of default_args so we only
	# add nulls for everything up to the first parameter with a default.
	for i in range(args.size() - method_meta.default_args.size()):
		defaults.append('null')

	# Add meta-data defaults.
	for i in range(method_meta.default_args.size()):
		var t = args[defaults.size()]['type']
		var value = ''
		if(_is_supported_default(t)):
			# strings are special, they need quotes around the value
			if(t == TYPE_STRING):
				value = str("'", str(method_meta.default_args[i]), "'")
			# Colors need the parens but things like Vector2 and Rect2 don't
			elif(t == TYPE_COLOR):
				value = str(_supported_defaults[t], '(', str(method_meta.default_args[i]), ')')
			elif(t == TYPE_OBJECT):
				if(str(method_meta.default_args[i]) == "[Object:null]"):
					value = str(_supported_defaults[t], 'null')
				else:
					value = str(_supported_defaults[t], str(method_meta.default_args[i]).to_lower())

			# Everything else puts the prefix (if one is there) form _supported_defaults
			# in front.  The to_lower is used b/c for some reason the defaults for
			# null, true, false are all "Null", "True", "False".
			else:
				value = str(_supported_defaults[t], str(method_meta.default_args[i]).to_lower())
		else:
			_lgr.warn(str(
				'Unsupported default param type:  ',method_meta.name, '-', args[defaults.size()].name, ' ', t, ' = ', method_meta.default_args[i]))
			value = str('unsupported=',t)
			has_unsupported_defaults = true

		defaults.append(value)

	# construct the string of parameters
	for i in range(args.size()):
		text += str(PARAM_PREFIX, args[i].name, '=', defaults[i])
		if(i != args.size() -1):
			text += ', '

	# if we don't know how to make a default then we have to return null b/c
	# it will cause a runtime error and it's one thing we could return to let
	# callers know it didn't work.
	if(has_unsupported_defaults):
		text = null

	return text

# ###############
# Public
# ###############

# Creates a delceration for a function based off of function metadata.  All
# types whose defaults are supported will have their values.  If a datatype
# is not supported and the parameter has a default, a warning message will be
# printed and the declaration will return null.
func get_decleration_text(meta):
	var param_text = _get_arg_text(meta)
	var text = null
	if(param_text != null):
		text = str('func ', meta.name, '(', param_text, '):')
	return text

# creates a call to the function in meta in the super's class.
func get_super_call_text(meta):
	var params = ''
	var all_supported = true

	for i in range(meta.args.size()):
		params += PARAM_PREFIX + meta.args[i].name
		if(meta.args.size() > 1 and i != meta.args.size() -1):
			params += ', '

	return str('.', meta.name, '(', params, ')')

func get_spy_call_parameters_text(meta):
	var called_with = 'null'
	if(meta.args.size() > 0):
		called_with = '['
		for i in range(meta.args.size()):
			called_with += str(PARAM_PREFIX, meta.args[i].name)
			if(i < meta.args.size() - 1):
				called_with += ', '
		called_with += ']'
	return called_with

func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger
               # ------------------------------------------------------------------------------
# This datastructure represents a simple one-to-many relationship.  It manages
# a dictionary of value/array pairs.  It ignores duplicates of both the "one"
# and the "many".
# ------------------------------------------------------------------------------
var _items = {}

# return the size of _items or the size of an element in _items if "one" was
# specified.
func size(one=null):
	var to_return = 0
	if(one == null):
		to_return = _items.size()
	elif(_items.has(one)):
		to_return = _items[one].size()
	return to_return

# Add an element to "one" if it does not already exist
func add(one, many_item):
	if(_items.has(one) and !_items[one].has(many_item)):
		_items[one].append(many_item)
	else:
		_items[one] = [many_item]

func clear():
	_items.clear()

func has(one, many_item):
	var to_return = false
	if(_items.has(one)):
		to_return = _items[one].has(many_item)
	return to_return

func to_s():
	var to_return = ''
	for key in _items:
		to_return += str(key, ":  ", _items[key], "\n")
	return to_return
            ################################################################################
#(G)odot (U)nit (T)est class
#
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################
# Description
# -----------
# Command line interface for the GUT unit testing tool.  Allows you to run tests
# from the command line instead of running a scene.  Place this script along with
# gut.gd into your scripts directory at the root of your project.  Once there you
# can run this script (from the root of your project) using the following command:
# 	godot -s -d test/gut/gut_cmdln.gd
#
# See the readme for a list of options and examples.  You can also use the -gh
# option to get more information about how to use the command line interface.
#
# Version 6.8.1
################################################################################

#-------------------------------------------------------------------------------
# Parses the command line arguments supplied into an array that can then be
# examined and parsed based on how the gut options work.
#-------------------------------------------------------------------------------
class CmdLineParser:
	var _used_options = []
	# an array of arrays.  Each element in this array will contain an option
	# name and if that option contains a value then it will have a sedond
	# element.  For example:
	# 	[[-gselect, test.gd], [-gexit]]
	var _opts = []

	func _init():
		for i in range(OS.get_cmdline_args().size()):
			var opt_val = OS.get_cmdline_args()[i].split('=')
			_opts.append(opt_val)

	# Parse out multiple comma delimited values from a command line
	# option.  Values are separated from option name with "=" and
	# additional values are comma separated.
	func _parse_array_value(full_option):
		var value = _parse_option_value(full_option)
		var split = value.split(',')
		return split

	# Parse out the value of an option.  Values are separated from
	# the option name with "="
	func _parse_option_value(full_option):
		if(full_option.size() > 1):
			return full_option[1]
		else:
			return null

	# Search _opts for an element that starts with the option name
	# specified.
	func find_option(name):
		var found = false
		var idx = 0

		while(idx < _opts.size() and !found):
			if(_opts[idx][0] == name):
				found = true
			else:
				idx += 1

		if(found):
			return idx
		else:
			return -1

	func get_array_value(option):
		_used_options.append(option)
		var to_return = []
		var opt_loc = find_option(option)
		if(opt_loc != -1):
			to_return = _parse_array_value(_opts[opt_loc])
			_opts.remove(opt_loc)

		return to_return

	# returns the value of an option if it was specified, null otherwise.  This
	# used to return the default but that became problemnatic when trying to
	# punch through the different places where values could be specified.
	func get_value(option):
		_used_options.append(option)
		var to_return = null
		var opt_loc = find_option(option)
		if(opt_loc != -1):
			to_return = _parse_option_value(_opts[opt_loc])
			_opts.remove(opt_loc)

		return to_return

	# returns true if it finds the option, false if not.
	func was_specified(option):
		_used_options.append(option)
		return find_option(option) != -1

	# Returns any unused command line options.  I found that only the -s and
	# script name come through from godot, all other options that godot uses
	# are not sent through OS.get_cmdline_args().
	#
	# This is a onetime thing b/c i kill all items in _used_options
	func get_unused_options():
		var to_return = []
		for i in range(_opts.size()):
			to_return.append(_opts[i][0])

		var script_option = to_return.find('-s')
		if script_option != -1:
			to_return.remove(script_option + 1)
			to_return.remove(script_option)

		while(_used_options.size() > 0):
			var index = to_return.find(_used_options[0].split("=")[0])
			if(index != -1):
				to_return.remove(index)
			_used_options.remove(0)

		return to_return

#-------------------------------------------------------------------------------
# Simple class to hold a command line option
#-------------------------------------------------------------------------------
class Option:
	var value = null
	var option_name = ''
	var default = null
	var description = ''

	func _init(name, default_value, desc=''):
		option_name = name
		default = default_value
		description = desc
		value = null#default_value

	func pad(value, size, pad_with=' '):
		var to_return = value
		for i in range(value.length(), size):
			to_return += pad_with

		return to_return

	func to_s(min_space=0):
		var subbed_desc = description
		if(subbed_desc.find('[default]') != -1):
			subbed_desc = subbed_desc.replace('[default]', str(default))
		return pad(option_name, min_space) + subbed_desc

#-------------------------------------------------------------------------------
# The high level interface between this script and the command line options
# supplied.  Uses Option class and CmdLineParser to extract information from
# the command line and make it easily accessible.
#-------------------------------------------------------------------------------
var options = []
var _opts = []
var _banner = ''

func add(name, default, desc):
	options.append(Option.new(name, default, desc))

func get_value(name):
	var found = false
	var idx = 0

	while(idx < options.size() and !found):
		if(options[idx].option_name == name):
			found = true
		else:
			idx += 1

	if(found):
		return options[idx].value
	else:
		print("COULD NOT FIND OPTION " + name)
		return null

func set_banner(banner):
	_banner = banner

func print_help():
	var longest = 0
	for i in range(options.size()):
		if(options[i].option_name.length() > longest):
			longest = options[i].option_name.length()

	print('---------------------------------------------------------')
	print(_banner)

	print("\nOptions\n-------")
	for i in range(options.size()):
		print('  ' + options[i].to_s(longest + 2))
	print('---------------------------------------------------------')

func print_options():
	for i in range(options.size()):
		print(options[i].option_name + '=' + str(options[i].value))

func parse():
	var parser = CmdLineParser.new()

	for i in range(options.size()):
		var t = typeof(options[i].default)
		# only set values that were specified at the command line so that
		# we can punch through default and config values correctly later.
		# Without this check, you can't tell the difference between the
		# defaults and what was specified, so you can't punch through
		# higher level options.
		if(parser.was_specified(options[i].option_name)):
			if(t == TYPE_INT):
				options[i].value = int(parser.get_value(options[i].option_name))
			elif(t == TYPE_STRING):
				options[i].value = parser.get_value(options[i].option_name)
			elif(t == TYPE_ARRAY):
				options[i].value = parser.get_array_value(options[i].option_name)
			elif(t == TYPE_BOOL):
				options[i].value = parser.was_specified(options[i].option_name)
			elif(t == TYPE_NIL):
				print(options[i].option_name + ' cannot be processed, it has a nil datatype')
			else:
				print(options[i].option_name + ' cannot be processed, it has unknown datatype:' + str(t))

	var unused = parser.get_unused_options()
	if(unused.size() > 0):
		print("Unrecognized options:  ", unused)
		return false

	return true
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################

# Some arbitrary string that should never show up by accident.  If it does, then
# shame on  you.
const ARG_NOT_SET = '_*_argument_*_is_*_not_set_*_'

# This hash holds the objects that are being watched, the signals that are being
# watched, and an array of arrays that contains arguments that were passed
# each time the signal was emitted.
#
# For example:
#	_watched_signals => {
#		ref1 => {
#			'signal1' => [[], [], []],
#			'signal2' => [[p1, p2]],
#			'signal3' => [[p1]]
#		},
#		ref2 => {
#			'some_signal' => [],
#			'other_signal' => [[p1, p2, p3], [p1, p2, p3], [p1, p2, p3]]
#		}
#	}
#
# In this sample:
#	- signal1 on the ref1 object was emitted 3 times and each time, zero
#	  parameters were passed.
#	- signal3 on ref1 was emitted once and passed a single parameter
#	- some_signal on ref2 was never emitted.
#	- other_signal on ref2 was emitted 3 times, each time with 3 parameters.
var _watched_signals = {}
var _utils = load('res://addons/gut/utils.gd').new()

func _add_watched_signal(obj, name):
	# SHORTCIRCUIT - ignore dupes
	if(_watched_signals.has(obj) and _watched_signals[obj].has(name)):
		return

	if(!_watched_signals.has(obj)):
		_watched_signals[obj] = {name:[]}
	else:
		_watched_signals[obj][name] = []
	obj.connect(name, Callable(self, '_on_watched_signal').bind(obj, name))

# This handles all the signals that are watched.  It supports up to 9 parameters
# which could be emitted by the signal and the two parameters used when it is
# connected via watch_signal.  I chose 9 since you can only specify up to 9
# parameters when dynamically calling a method via call (per the Godot
# documentation, i.e. some_object.call('some_method', 1, 2, 3...)).
#
# Based on the documentation of emit_signal, it appears you can only pass up
# to 4 parameters when firing a signal.  I haven't verified this, but this should
# future proof this some if the value ever grows.
func _on_watched_signal(arg1=ARG_NOT_SET, arg2=ARG_NOT_SET, arg3=ARG_NOT_SET, \
                        arg4=ARG_NOT_SET, arg5=ARG_NOT_SET, arg6=ARG_NOT_SET, \
						arg7=ARG_NOT_SET, arg8=ARG_NOT_SET, arg9=ARG_NOT_SET, \
						arg10=ARG_NOT_SET, arg11=ARG_NOT_SET):
	var args = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11]

	# strip off any unused vars.
	var idx = args.size() -1
	while(str(args[idx]) == ARG_NOT_SET):
		args.remove(idx)
		idx -= 1

	# retrieve object and signal name from the array and remove them.  These
	# will always be at the end since they are added when the connect happens.
	var signal_name = args[args.size() -1]
	args.pop_back()
	var object = args[args.size() -1]
	args.pop_back()

	_watched_signals[object][signal_name].append(args)

func does_object_have_signal(object, signal_name):
	var signals = object.get_signal_list()
	for i in range(signals.size()):
		if(signals[i]['name'] == signal_name):
			return true
	return false

func watch_signals(object):
	var signals = object.get_signal_list()
	for i in range(signals.size()):
		_add_watched_signal(object, signals[i]['name'])

func watch_signal(object, signal_name):
	var did = false
	if(does_object_have_signal(object, signal_name)):
		_add_watched_signal(object, signal_name)
		did = true
	return did

func get_emit_count(object, signal_name):
	var to_return = -1
	if(is_watching(object, signal_name)):
		to_return = _watched_signals[object][signal_name].size()
	return to_return

func did_emit(object, signal_name):
	var did = false
	if(is_watching(object, signal_name)):
		did = get_emit_count(object, signal_name) != 0
	return did

func print_object_signals(object):
	var list = object.get_signal_list()
	for i in range(list.size()):
		print(list[i].name, "\n  ", list[i])

func get_signal_parameters(object, signal_name, index=-1):
	var params = null
	if(is_watching(object, signal_name)):
		var all_params = _watched_signals[object][signal_name]
		if(all_params.size() > 0):
			if(index == -1):
				index = all_params.size() -1
			params = all_params[index]
	return params

func is_watching_object(object):
	return _watched_signals.has(object)

func is_watching(object, signal_name):
	return _watched_signals.has(object) and _watched_signals[object].has(signal_name)

func clear():
	for obj in _watched_signals:
		for signal_name in _watched_signals[obj]:
			if(_utils.is_not_freed(obj)):
				obj.disconnect(signal_name, Callable(self, '_on_watched_signal'))
	_watched_signals.clear()

# Returns a list of all the signal names that were emitted by the object.
# If the object is not being watched then an empty list is returned.
func get_signals_emitted(obj):
	var emitted = []
	if(is_watching_object(obj)):
		for signal_name in _watched_signals[obj]:
			if(_watched_signals[obj][signal_name].size() > 0):
				emitted.append(signal_name)

	return emitted
 RSCC      �  G  (�/�`�� ��Y7`k�0Àt�a;[7K�Ͷ�{c�"�.����2E�	��eu��/��/b��-D I G ����!k�P6��l�WՋ$������'åxn������er�t�����<�n�������2�X��<$�<7�kb�cj�2(�b?UH�6���]t��z��������m�G�����i4%����D/7�u�|S-����ZE��A𗍫�1'��c�X�I��[��R��=�ɠl��l���S1C�0=�r��1|.;�����U�;84p�DhT `\<�-4*���+8�I,�hY0��nꒀ��H�ˍ$u㹺\�}.R5.K
N��&w3��7jV����1�]�Q-c�HdD$I
RlP!����%��$+��o0�i��`��|ת�__�'��
d��L�oE�@�M:���M�h
(>�U���J����+�={�ɋc0�6�u�V����.�D��V�	�
��۳��Je<	�NTF_/)��ռ��?��X�����X��w�	U�� NԂ �ԋ�؊؜��P����1y* %RSCC [remap]

importer="font_data_bmfont"
type="FontFile"
uid="uid://dvt6p1ud2p1lb"
path="res://.godot/imported/source_code_pro.fnt-042fb383b3c7b4c19e67c852f7fbefca.fontdata"
      # {
#   instance_id_or_path1:{
#       method1:[ [p1, p2], [p1, p2] ],
#       method2:[ [p1, p2], [p1, p2] ]
#   },
#   instance_id_or_path1:{
#       method1:[ [p1, p2], [p1, p2] ],
#       method2:[ [p1, p2], [p1, p2] ]
#   },
# }
var _calls = {}
var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()

func _get_params_as_string(params):
	var to_return = ''
	if(params == null):
		return ''

	for i in range(params.size()):
		if(params[i] == null):
			to_return += 'null'
		else:
			if(typeof(params[i]) == TYPE_STRING):
				to_return += str('"', params[i], '"')
			else:
				to_return += str(params[i])
		if(i != params.size() -1):
			to_return += ', '
	return to_return

func add_call(variant, method_name, parameters=null):
	if(!_calls.has(variant)):
		_calls[variant] = {}

	if(!_calls[variant].has(method_name)):
		_calls[variant][method_name] = []

	_calls[variant][method_name].append(parameters)

func was_called(variant, method_name, parameters=null):
	var to_return = false
	if(_calls.has(variant) and _calls[variant].has(method_name)):
		if(parameters):
			to_return =  _calls[variant][method_name].has(parameters)
		else:
			to_return = true
	return to_return

func get_call_parameters(variant, method_name, index=-1):
	var to_return = null
	var get_index = -1

	if(_calls.has(variant) and _calls[variant].has(method_name)):
		var call_size = _calls[variant][method_name].size()
		if(index == -1):
			# get the most recent call by default
			get_index =  call_size -1
		else:
			get_index = index

		if(get_index < call_size):
			to_return = _calls[variant][method_name][get_index]
		else:
			_lgr.error(str('Specified index ', index, ' is outside range of the number of registered calls:  ', call_size))
			
	return to_return

func call_count(instance, method_name, parameters=null):
	var to_return = 0

	if(was_called(instance, method_name)):
		if(parameters):
			for i in range(_calls[instance][method_name].size()):
				if(_calls[instance][method_name][i] == parameters):
					to_return += 1
		else:
			to_return = _calls[instance][method_name].size()
	return to_return

func clear():
	_calls = {}

func get_call_list_as_string(instance):
	var to_return = ''
	if(_calls.has(instance)):
		for method in _calls[instance]:
			for i in range(_calls[instance][method].size()):
				to_return += str(method, '(', _get_params_as_string(_calls[instance][method][i]), ")\n")
	return to_return

func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger
      # {
# 	inst_id_or_path1:{
# 		method_name1: [StubParams, StubParams],
# 		method_name2: [StubParams, StubParams]
# 	},
# 	inst_id_or_path2:{
# 		method_name1: [StubParams, StubParams],
# 		method_name2: [StubParams, StubParams]
# 	}
# }
var returns = {}
var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()

func _is_instance(obj):
	return typeof(obj) == TYPE_OBJECT and !obj.has_method('new')

func _make_key_from_metadata(doubled):
	var to_return = doubled.__gut_metadata_.path
	if(doubled.__gut_metadata_.subpath != ''):
		to_return += str('-', doubled.__gut_metadata_.subpath)
	return to_return

# Creates they key for the returns hash based on the type of object passed in
# obj could be a string of a path to a script with an optional subpath or
# it could be an instance of a doubled object.
func _make_key_from_variant(obj, subpath=null):
	var to_return = null

	match typeof(obj):
		TYPE_STRING:
			# this has to match what is done in _make_key_from_metadata
			to_return = obj
			if(subpath != null and subpath != ''):
				to_return += str('-', subpath)
		TYPE_OBJECT:
			if(_is_instance(obj)):
				to_return = _make_key_from_metadata(obj)
			elif(_utils.is_native_class(obj)):
				to_return = _utils.get_native_class_name(obj)
			else:
				to_return = obj.resource_path
	return to_return

func _add_obj_method(obj, method, subpath=null):
	var key = _make_key_from_variant(obj, subpath)
	if(_is_instance(obj)):
		key = obj

	if(!returns.has(key)):
		returns[key] = {}
	if(!returns[key].has(method)):
		returns[key][method] = []

	return key

# ##############
# Public
# ##############

# TODO: This method is only used in tests and should be refactored out.  It
# does not support inner classes and isn't helpful.
func set_return(obj, method, value, parameters=null):
	var key = _add_obj_method(obj, method)
	var sp = _utils.StubParams.new(key, method)
	sp.parameters = parameters
	sp.return_val = value
	returns[key][method].append(sp)

func add_stub(stub_params):
	var key = _add_obj_method(stub_params.stub_target, stub_params.stub_method, stub_params.target_subpath)
	returns[key][stub_params.stub_method].append(stub_params)

# Searches returns for an entry that matches the instance or the class that
# passed in obj is.
#
# obj can be an instance, class, or a path.
func _find_stub(obj, method, parameters=null):
	var key = _make_key_from_variant(obj)
	var to_return = null

	if(_is_instance(obj)):
		if(returns.has(obj) and returns[obj].has(method)):
			key = obj
		elif(obj.get('__gut_metadata_')):
			key = _make_key_from_metadata(obj)

	if(returns.has(key) and returns[key].has(method)):
		var param_idx = -1
		var null_idx = -1

		for i in range(returns[key][method].size()):
			if(returns[key][method][i].parameters == parameters):
				param_idx = i
			if(returns[key][method][i].parameters == null):
				null_idx = i

		# We have matching parameter values so return the stub value for that
		if(param_idx != -1):
			to_return = returns[key][method][param_idx]
		# We found a case where the parameters were not specified so return
		# parameters for that
		elif(null_idx != -1):
			to_return = returns[key][method][null_idx]
		else:
			_lgr.warn(str('Call to [', method, '] was not stubbed for the supplied parameters ', parameters, '.  Null was returned.'))

	return to_return

# Gets a stubbed return value for the object and method passed in.  If the
# instance was stubbed it will use that, otherwise it will use the path and
# subpath of the object to try to find a value.
#
# It will also use the optional list of parameter values to find a value.  If
# the object was stubbed with no parameters than any parameters will match.
# If it was stubbed with specific parameter values then it will try to match.
# If the parameters do not match BUT there was also an empty parameter list stub
# then it will return those.
# If it cannot find anything that matches then null is returned.for
#
# Parameters
# obj:  this should be an instance of a doubled object.
# method:  the method called
# parameters:  optional array of parameter vales to find a return value for.
func get_return(obj, method, parameters=null):
	var stub_info = _find_stub(obj, method, parameters)

	if(stub_info != null):
		return stub_info.return_val
	else:
		return null

func should_call_super(obj, method, parameters=null):
	var stub_info = _find_stub(obj, method, parameters)
	if(stub_info != null):
		return stub_info.call_super
	else:
		# this log message is here because of how the generated doubled scripts
		# are structured.  With this log msg here, you will only see one
		# "unstubbed" info instead of multiple.
		_lgr.info('Unstubbed call to ' + method + '::' + str(obj))
		return false


func clear():
	returns.clear()

func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger

func to_s():
	var text = ''
	for thing in returns:
		text += str(thing) + "\n"
		for method in returns[thing]:
			text += str("\t", method, "\n")
			for i in range(returns[thing][method].size()):
				text += "\t\t" + returns[thing][method][i].to_s() + "\n"
	return text
 var return_val = null
var stub_target = null
var target_subpath = null
var parameters = null
var stub_method = null
var call_super = false

const NOT_SET = '|_1_this_is_not_set_1_|'

func _init(target=null, method=null, subpath=null):
	stub_target = target
	stub_method = method
	target_subpath = subpath

func to_return(val):
	return_val = val
	call_super = false
	return self

func to_do_nothing():
	return to_return(null)

func to_call_super():
	call_super = true
	return self

func when_passed(p1=NOT_SET,p2=NOT_SET,p3=NOT_SET,p4=NOT_SET,p5=NOT_SET,p6=NOT_SET,p7=NOT_SET,p8=NOT_SET,p9=NOT_SET,p10=NOT_SET):
	parameters = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]
	var idx = 0
	while(idx < parameters.size()):
		if(str(parameters[idx]) == NOT_SET):
			parameters.remove(idx)
		else:
			idx += 1
	return self

func to_s():
	var base_string = str(stub_target, '[', target_subpath, '].', stub_method)
	if(call_super):
		base_string += " to call SUPER"
	else:
		base_string += str(' with (', parameters, ') = ', return_val)
	return base_string
      # ------------------------------------------------------------------------------
# Contains all the results of a single test.  Allows for multiple asserts results
# and pending calls.
# ------------------------------------------------------------------------------
class Test:
	var pass_texts = []
	var fail_texts = []
	var pending_texts = []

	func to_s():
		var pad = '     '
		var to_return = ''
		for i in range(fail_texts.size()):
			to_return += str(pad, 'FAILED:  ', fail_texts[i], "\n")
		for i in range(pending_texts.size()):
			to_return += str(pad, 'Pending:  ', pending_texts[i], "\n")
		return to_return

# ------------------------------------------------------------------------------
# Contains all the results for a single test-script/inner class.  Persists the
# names of the tests and results and the order in which  the tests were run.
# ------------------------------------------------------------------------------
class TestScript:
	var name = 'NOT_SET'
	#
	var _tests = {}
	var _test_order = []

	func _init(script_name):
		name = script_name

	func get_pass_count():
		var count = 0
		for key in _tests:
			count += _tests[key].pass_texts.size()
		return count

	func get_fail_count():
		var count = 0
		for key in _tests:
			count += _tests[key].fail_texts.size()
		return count

	func get_pending_count():
		var count = 0
		for key in _tests:
			count += _tests[key].pending_texts.size()
		return count

	func get_test_obj(name):
		if(!_tests.has(name)):
			_tests[name] = Test.new()
			_test_order.append(name)
		return _tests[name]

	func add_pass(test_name, reason):
		var t = get_test_obj(test_name)
		t.pass_texts.append(reason)

	func add_fail(test_name, reason):
		var t = get_test_obj(test_name)
		t.fail_texts.append(reason)

	func add_pending(test_name, reason):
		var t = get_test_obj(test_name)
		t.pending_texts.append(reason)

# ------------------------------------------------------------------------------
# Summary Class
#
# This class holds the results of all the test scripts and Inner Classes that
# were run.
# -------------------------------------------d-----------------------------------
var _scripts = []

func add_script(name):
	_scripts.append(TestScript.new(name))

func get_scripts():
	return _scripts

func get_current_script():
	return _scripts[_scripts.size() - 1]

func add_test(test_name):
	get_current_script().get_test_obj(test_name)

func add_pass(test_name, reason = ''):
	get_current_script().add_pass(test_name, reason)

func add_fail(test_name, reason = ''):
	get_current_script().add_fail(test_name, reason)

func add_pending(test_name, reason = ''):
	get_current_script().add_pending(test_name, reason)

func get_test_text(test_name):
	return test_name + "\n" + get_current_script().get_test_obj(test_name).to_s()

# Gets the count of unique script names minus the .<Inner Class Name> at the
# end.  Used for displaying the number of scripts without including all the
# Inner Classes.
func get_non_inner_class_script_count():
	var count = 0
	var unique_scripts = {}
	for i in range(_scripts.size()):
		var ext_loc = _scripts[i].name.rfind('.gd.')
		if(ext_loc == -1):
			unique_scripts[_scripts[i].name] = 1
		else:
			unique_scripts[_scripts[i].name.substr(0, ext_loc + 3)] = 1
	return unique_scripts.keys().size()

func get_totals():
	var totals = {
		passing = 0,
		pending = 0,
		failing = 0,
		tests = 0,
		scripts = 0
	}

	for s in range(_scripts.size()):
		totals.passing += _scripts[s].get_pass_count()
		totals.pending += _scripts[s].get_pending_count()
		totals.failing += _scripts[s].get_fail_count()
		totals.tests += _scripts[s]._test_order.size()

	totals.scripts = get_non_inner_class_script_count()

	return totals

func get_summary_text():
	var _totals = get_totals()

	var to_return = ''
	for s in range(_scripts.size()):
		if(_scripts[s].get_fail_count() > 0 or _scripts[s].get_pending_count() > 0):
			to_return += _scripts[s].name + "\n"
		for t in range(_scripts[s]._test_order.size()):
			var tname = _scripts[s]._test_order[t]
			var test = _scripts[s].get_test_obj(tname)
			if(test.fail_texts.size() > 0 or test.pending_texts.size() > 0):
				to_return += str('  - ', tname, "\n", test.to_s())

	var header = "***  Totals  ***\n"
	header += str('  scripts:          ', get_non_inner_class_script_count(), "\n")
	header += str('  tests:            ', _totals.tests, "\n")
	header += str('  passing asserts:  ', _totals.passing, "\n")
	header += str('  failing asserts:  ',_totals.failing, "\n")
	header += str('  pending:          ', _totals.pending, "\n")

	return to_return + "\n" + header
      ################################################################################
#(G)odot (U)nit (T)est class
#
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################
# View readme for usage details.
#
# Version - see gut.gd
################################################################################
# Class that all test scripts must extend.
#
# This provides all the asserts and other testing features.  Test scripts are
# run by the Gut class in gut.gd
################################################################################
extends Node

# ------------------------------------------------------------------------------
# Helper class to hold info for objects to double.  This extracts info and has
# some convenience methods.  This is key in being able to make the "smart double"
# method which makes doubling much easier for the user.
# ------------------------------------------------------------------------------
class DoubleInfo:
	var path
	var subpath
	var strategy
	var make_partial
	var extension
	var _utils = load('res://addons/gut/utils.gd').new()
	var _is_native = false

	# Flexible init method.  p2 can be subpath or stategy unless p3 is
	# specified, then p2 must be subpath and p3 is strategy.
	#
	# Examples:
	#   (object_to_double)
	#   (object_to_double, subpath)
	#   (object_to_double, strategy)
	#   (object_to_double, subpath, strategy)
	func _init(thing, p2=null, p3=null):
		strategy = p2

		if(typeof(p2) == TYPE_STRING):
			strategy = p3
			subpath = p2

		if(typeof(thing) == TYPE_OBJECT):
			if(_utils.is_native_class(thing)):
				path = thing
				_is_native = true
				extension = 'native_class_not_used'
			else:
				path = thing.resource_path
		else:
			path = thing

		if(!_is_native):
			extension = path.get_extension()

	func is_scene():
		return extension == 'tscn'

	func is_script():
		return extension == 'gd'

	func is_native():
		return _is_native

# ------------------------------------------------------------------------------
# Begin test.gd
# ------------------------------------------------------------------------------

# constant for signal when calling yield_for
const YIELD = 'timeout'

# Need a reference to the instance that is running the tests.  This
# is set by the gut class when it runs the tests.  This gets you
# access to the asserts in the tests you write.
var gut = null
var passed = false
var failed = false
var _disable_strict_datatype_checks = false
# Holds all the text for a test's fail/pass.  This is used for testing purposes
# to see the text of a failed sub-test in test_test.gd
var _fail_pass_text = []

# Hash containing all the built in types in Godot.  This provides an English
# name for the types that corosponds with the type constants defined in the
# engine.  This is used for priting out messages when comparing types fails.
var types = {}

func _init_types_dictionary():
	types[TYPE_NIL] = 'TYPE_NIL'
	types[TYPE_BOOL] = 'Bool'
	types[TYPE_INT] = 'Int'
	types[TYPE_FLOAT] = 'Float/Real'
	types[TYPE_STRING] = 'String'
	types[TYPE_VECTOR2] = 'Vector2'
	types[TYPE_RECT2] = 'Rect2'
	types[TYPE_VECTOR3] = 'Vector3'
	#types[8] = 'Matrix32'
	types[TYPE_PLANE] = 'Plane'
	types[TYPE_QUATERNION] = 'QUAT'
	types[TYPE_AABB] = 'AABB'
	#types[12] = 'Matrix3'
	types[TYPE_TRANSFORM3D] = 'Transform3D'
	types[TYPE_COLOR] = 'Color'
	#types[15] = 'Image'
	types[TYPE_NODE_PATH] = 'Node Path3D'
	types[TYPE_RID] = 'RID'
	types[TYPE_OBJECT] = 'TYPE_OBJECT'
	#types[19] = 'TYPE_INPUT_EVENT'
	types[TYPE_DICTIONARY] = 'Dictionary'
	types[TYPE_ARRAY] = 'Array'
	types[TYPE_PACKED_BYTE_ARRAY] = 'TYPE_PACKED_BYTE_ARRAY'
	types[TYPE_PACKED_INT32_ARRAY] = 'TYPE_PACKED_INT32_ARRAY'
	types[TYPE_PACKED_FLOAT32_ARRAY] = 'TYPE_PACKED_FLOAT32_ARRAY'
	types[TYPE_PACKED_STRING_ARRAY] = 'TYPE_PACKED_STRING_ARRAY'
	types[TYPE_PACKED_VECTOR2_ARRAY] = 'TYPE_PACKED_VECTOR2_ARRAY'
	types[TYPE_PACKED_VECTOR3_ARRAY] = 'TYPE_PACKED_VECTOR3_ARRAY'
	types[TYPE_PACKED_COLOR_ARRAY] = 'TYPE_PACKED_COLOR_ARRAY'
	types[TYPE_MAX] = 'TYPE_MAX'

const EDITOR_PROPERTY = PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_DEFAULT
const VARIABLE_PROPERTY = PROPERTY_USAGE_SCRIPT_VARIABLE

# Summary counts for the test.
var _summary = {
	asserts = 0,
	passed = 0,
	failed = 0,
	tests = 0,
	pending = 0
}

# This is used to watch signals so we can make assertions about them.
var _signal_watcher = load('res://addons/gut/signal_watcher.gd').new()

# Convenience copy of _utils.DOUBLE_STRATEGY
var DOUBLE_STRATEGY = null
var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()

func _init():
	_init_types_dictionary()
	DOUBLE_STRATEGY = _utils.DOUBLE_STRATEGY # yes, this is right

# ------------------------------------------------------------------------------
# Fail an assertion.  Causes test and script to fail as well.
# ------------------------------------------------------------------------------
func _fail(text):
	_summary.asserts += 1
	_summary.failed += 1
	var msg = 'FAILED:  ' + text
	_fail_pass_text.append(msg)
	if(gut):
		gut.p(msg, gut.LOG_LEVEL_FAIL_ONLY)
		gut._fail(text)

# ------------------------------------------------------------------------------
# Pass an assertion.
# ------------------------------------------------------------------------------
func _pass(text):
	_summary.asserts += 1
	_summary.passed += 1
	var msg = "PASSED:  " + text
	_fail_pass_text.append(msg)
	if(gut):
		gut.p(msg, gut.LOG_LEVEL_ALL_ASSERTS)
		gut._pass(text)

# ------------------------------------------------------------------------------
# Checks if the datatypes passed in match.  If they do not then this will cause
# a fail to occur.  If they match then TRUE is returned, FALSE if not.  This is
# used in all the assertions that compare values.
# ------------------------------------------------------------------------------
func _do_datatypes_match__fail_if_not(got, expected, text):
	var passed = true

	if(!_disable_strict_datatype_checks):
		var got_type = typeof(got)
		var expect_type = typeof(expected)
		if(got_type != expect_type and got != null and expected != null):
			# If we have a mismatch between float and int (types 2 and 3) then
			# print out a warning but do not fail.
			if([2, 3].has(got_type) and [2, 3].has(expect_type)):
				_lgr.warn(str('Warn:  Float/Int comparison.  Got ', types[got_type], ' but expected ', types[expect_type]))
			else:
				_fail('Cannot compare ' + types[got_type] + '[' + str(got) + '] to ' + types[expect_type] + '[' + str(expected) + '].  ' + text)
				passed = false

	return passed

# ------------------------------------------------------------------------------
# Create a string that lists all the methods that were called on an spied
# instance.
# ------------------------------------------------------------------------------
func _get_desc_of_calls_to_instance(inst):
	var BULLET = '  * '
	var calls = gut.get_spy().get_call_list_as_string(inst)
	# indent all the calls
	calls = BULLET + calls.replace("\n", "\n" + BULLET)
	# remove trailing newline and bullet
	calls = calls.substr(0, calls.length() - BULLET.length() - 1)
	return "Calls made on " + str(inst) + "\n" + calls

# ------------------------------------------------------------------------------
# Signal assertion helper.  Do not call directly, use _can_make_signal_assertions
# ------------------------------------------------------------------------------
func _fail_if_does_not_have_signal(object, signal_name):
	var did_fail = false
	if(!_signal_watcher.does_object_have_signal(object, signal_name)):
		_fail(str('Object ', object, ' does not have the signal [', signal_name, ']'))
		did_fail = true
	return did_fail
# ------------------------------------------------------------------------------
# Signal assertion helper.  Do not call directly, use _can_make_signal_assertions
# ------------------------------------------------------------------------------
func _fail_if_not_watching(object):
	var did_fail = false
	if(!_signal_watcher.is_watching_object(object)):
		_fail(str('Cannot make signal assertions because the object ', object, \
				  ' is not being watched.  Call watch_signals(some_object) to be able to make assertions about signals.'))
		did_fail = true
	return did_fail

# ------------------------------------------------------------------------------
# Returns text that contains original text and a list of all the signals that
# were emitted for the passed in object.
# ------------------------------------------------------------------------------
func _get_fail_msg_including_emitted_signals(text, object):
	return str(text," (Signals emitted: ", _signal_watcher.get_signals_emitted(object), ")")

# ------------------------------------------------------------------------------
# This validates that parameters is an array and generates a specific error
# and a failure with a specific message
# ------------------------------------------------------------------------------
func _fail_if_parameters_not_array(parameters):
	var invalid = parameters != null and typeof(parameters) != TYPE_ARRAY
	if(invalid):
		_lgr.error('The "parameters" parameter must be an array of expected parameter values.')
		_fail('Cannot compare paramter values because an array was not passed.')
	return invalid
# #######################
# Virtual Methods
# #######################

# alias for prerun_setup
func before_all():
	pass

# alias for setup
func before_each():
	pass

# alias for postrun_teardown
func after_all():
	pass

# alias for teardown
func after_each():
	pass

# #######################
# Public
# #######################

func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger


# #######################
# Asserts
# #######################

# ------------------------------------------------------------------------------
# Asserts that the expected value equals the value got.
# ------------------------------------------------------------------------------
func assert_eq(got, expected, text=""):
	var disp = "[" + str(got) + "] expected to equal [" + str(expected) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, expected, text)):
		if(expected != got):
			_fail(disp)
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the value got does not equal the "not expected" value.
# ------------------------------------------------------------------------------
func assert_ne(got, not_expected, text=""):
	var disp = "[" + str(got) + "] expected to be anything except [" + str(not_expected) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, not_expected, text)):
		if(got == not_expected):
			_fail(disp)
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the expected value almost equals the value got.
# ------------------------------------------------------------------------------
func assert_almost_eq(got, expected, error_interval, text=''):
	var disp = "[" + str(got) + "] expected to equal [" + str(expected) + "] +/- [" + str(error_interval) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, expected, text) and _do_datatypes_match__fail_if_not(got, error_interval, text)):
		if(got < (expected - error_interval) or got > (expected + error_interval)):
			_fail(disp)
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the expected value does not almost equal the value got.
# ------------------------------------------------------------------------------
func assert_almost_ne(got, not_expected, error_interval, text=''):
	var disp = "[" + str(got) + "] expected to not equal [" + str(not_expected) + "] +/- [" + str(error_interval) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, not_expected, text) and _do_datatypes_match__fail_if_not(got, error_interval, text)):
		if(got < (not_expected - error_interval) or got > (not_expected + error_interval)):
			_pass(disp)
		else:
			_fail(disp)

# ------------------------------------------------------------------------------
# Asserts got is greater than expected
# ------------------------------------------------------------------------------
func assert_gt(got, expected, text=""):
	var disp = "[" + str(got) + "] expected to be > than [" + str(expected) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, expected, text)):
		if(got > expected):
			_pass(disp)
		else:
			_fail(disp)

# ------------------------------------------------------------------------------
# Asserts got is less than expected
# ------------------------------------------------------------------------------
func assert_lt(got, expected, text=""):
	var disp = "[" + str(got) + "] expected to be < than [" + str(expected) + "]:  " + text
	if(_do_datatypes_match__fail_if_not(got, expected, text)):
		if(got < expected):
			_pass(disp)
		else:
			_fail(disp)

# ------------------------------------------------------------------------------
# asserts that got is true
# ------------------------------------------------------------------------------
func assert_true(got, text=""):
	if(!got):
		_fail(text)
	else:
		_pass(text)

# ------------------------------------------------------------------------------
# Asserts that got is false
# ------------------------------------------------------------------------------
func assert_false(got, text=""):
	if(got):
		_fail(text)
	else:
		_pass(text)

# ------------------------------------------------------------------------------
# Asserts value is between (inclusive) the two expected values.
# ------------------------------------------------------------------------------
func assert_between(got, expect_low, expect_high, text=""):
	var disp = "[" + str(got) + "] expected to be between [" + str(expect_low) + "] and [" + str(expect_high) + "]:  " + text

	if(_do_datatypes_match__fail_if_not(got, expect_low, text) and _do_datatypes_match__fail_if_not(got, expect_high, text)):
		if(expect_low > expect_high):
			disp = "INVALID range.  [" + str(expect_low) + "] is not less than [" + str(expect_high) + "]"
			_fail(disp)
		else:
			if(got < expect_low or got > expect_high):
				_fail(disp)
			else:
				_pass(disp)

# ------------------------------------------------------------------------------
# Uses the 'has' method of the object passed in to determine if it contains
# the passed in element.
# ------------------------------------------------------------------------------
func assert_has(obj, element, text=""):
	var disp = str('Expected [', obj, '] to contain value:  [', element, ']:  ', text)
	if(obj.has(element)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func assert_does_not_have(obj, element, text=""):
	var disp = str('Expected [', obj, '] to NOT contain value:  [', element, ']:  ', text)
	if(obj.has(element)):
		_fail(disp)
	else:
		_pass(disp)

# ------------------------------------------------------------------------------
# Asserts that a file exists
# ------------------------------------------------------------------------------
func assert_file_exists(file_path):
	var disp = 'expected [' + file_path + '] to exist.'
	var f = File.new()
	if(f.file_exists(file_path)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Asserts that a file should not exist
# ------------------------------------------------------------------------------
func assert_file_does_not_exist(file_path):
	var disp = 'expected [' + file_path + '] to NOT exist'
	var f = File.new()
	if(!f.file_exists(file_path)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Asserts the specified file is empty
# ------------------------------------------------------------------------------
func assert_file_empty(file_path):
	var disp = 'expected [' + file_path + '] to be empty'
	var f = File.new()
	if(f.file_exists(file_path) and gut.is_file_empty(file_path)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Asserts the specified file is not empty
# ------------------------------------------------------------------------------
func assert_file_not_empty(file_path):
	var disp = 'expected [' + file_path + '] to contain data'
	if(!gut.is_file_empty(file_path)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Asserts the object has the specified method
# ------------------------------------------------------------------------------
func assert_has_method(obj, method):
	assert_true(obj.has_method(method), 'Should have method: ' + method)

# Old deprecated method name
func assert_get_set_methods(obj, property, default, set_to):
	_lgr.deprecated('assert_get_set_methods', 'assert_accessors')
	assert_accessors(obj, property, default, set_to)

# ------------------------------------------------------------------------------
# Verifies the object has get and set methods for the property passed in.  The
# property isn't tied to anything, just a name to be appended to the end of
# get_ and set_.  Asserts the get_ and set_ methods exist, if not, it stops there.
# If they exist then it asserts get_ returns the expected default then calls
# set_ and asserts get_ has the value it was set to.
# ------------------------------------------------------------------------------
func assert_accessors(obj, property, default, set_to):
	var fail_count = _summary.failed
	var get = 'get_' + property
	var set = 'set_' + property
	assert_has_method(obj, get)
	assert_has_method(obj, set)
	# SHORT CIRCUIT
	if(_summary.failed > fail_count):
		return
	assert_eq(obj.call(get), default, 'It should have the expected default value.')
	obj.call(set, set_to)
	assert_eq(obj.call(get), set_to, 'The set value should have been returned.')


# ---------------------------------------------------------------------------
# Property search helper.  Used to retrieve Dictionary of specified property
# from passed object. Returns null if not found.
# If provided, property_usage constrains the type of property returned by
# passing either:
# EDITOR_PROPERTY for properties defined as: export(int) var some_value
# VARIABLE_PROPERTY for properties defunded as: var another_value
# ---------------------------------------------------------------------------
func _find_object_property(obj, property_name, property_usage=null):
	var result = null
	var found = false
	var properties = obj.get_property_list()

	while !found and !properties.is_empty():
		var property = properties.pop_back()
		if property['name'] == property_name:
			if property_usage == null or property['usage'] == property_usage:
				result = property
				found = true
	return result

# ------------------------------------------------------------------------------
# Asserts a class exports a variable.
# ------------------------------------------------------------------------------
func assert_exports(obj, property_name, type):
	var disp = 'expected %s to have editor property [%s]' % [obj, property_name]
	var property = _find_object_property(obj, property_name, EDITOR_PROPERTY)
	if property != null:
		disp += ' of type [%s]. Got type [%s].' % [types[type], types[property['type']]]
		if property['type'] == type:
			_pass(disp)
		else:
			_fail(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Signal assertion helper.
#
# Verifies that the object and signal are valid for making signal assertions.
# This will fail with specific messages that indicate why they are not valid.
# This returns true/false to indicate if the object and signal are valid.
# ------------------------------------------------------------------------------
func _can_make_signal_assertions(object, signal_name):
	return !(_fail_if_not_watching(object) or _fail_if_does_not_have_signal(object, signal_name))

# ------------------------------------------------------------------------------
# Watch the signals for an object.  This must be called before you can make
# any assertions about the signals themselves.
# ------------------------------------------------------------------------------
func watch_signals(object):
	_signal_watcher.watch_signals(object)

# ------------------------------------------------------------------------------
# Asserts that a signal has been emitted at least once.
#
# This will fail with specific messages if the object is not being watched or
# the object does not have the specified signal
# ------------------------------------------------------------------------------
func assert_signal_emitted(object, signal_name, text=""):
	var disp = str('Expected object ', object, ' to have emitted signal [', signal_name, ']:  ', text)
	if(_can_make_signal_assertions(object, signal_name)):
		if(_signal_watcher.did_emit(object, signal_name)):
			_pass(disp)
		else:
			_fail(_get_fail_msg_including_emitted_signals(disp, object))

# ------------------------------------------------------------------------------
# Asserts that a signal has not been emitted.
#
# This will fail with specific messages if the object is not being watched or
# the object does not have the specified signal
# ------------------------------------------------------------------------------
func assert_signal_not_emitted(object, signal_name, text=""):
	var disp = str('Expected object ', object, ' to NOT emit signal [', signal_name, ']:  ', text)
	if(_can_make_signal_assertions(object, signal_name)):
		if(_signal_watcher.did_emit(object, signal_name)):
			_fail(disp)
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Asserts that a signal was fired with the specified parameters.  The expected
# parameters should be passed in as an array.  An optional index can be passed
# when a signal has fired more than once.  The default is to retrieve the most
# recent emission of the signal.
#
# This will fail with specific messages if the object is not being watched or
# the object does not have the specified signal
# ------------------------------------------------------------------------------
func assert_signal_emitted_with_parameters(object, signal_name, parameters, index=-1):
	var disp = str('Expected object ', object, ' to emit signal [', signal_name, '] with parameters ', parameters, ', got ')
	if(_can_make_signal_assertions(object, signal_name)):
		if(_signal_watcher.did_emit(object, signal_name)):
			var parms_got = _signal_watcher.get_signal_parameters(object, signal_name, index)
			if(parameters == parms_got):
				_pass(str(disp, parms_got))
			else:
				_fail(str(disp, parms_got))
		else:
			var text = str('Object ', object, ' did not emit signal [', signal_name, ']')
			_fail(_get_fail_msg_including_emitted_signals(text, object))

# ------------------------------------------------------------------------------
# Assert that a signal has been emitted a specific number of times.
#
# This will fail with specific messages if the object is not being watched or
# the object does not have the specified signal
# ------------------------------------------------------------------------------
func assert_signal_emit_count(object, signal_name, times, text=""):

	if(_can_make_signal_assertions(object, signal_name)):
		var count = _signal_watcher.get_emit_count(object, signal_name)
		var disp = str('Expected the signal [', signal_name, '] emit count of [', count, '] to equal [', times, ']: ', text)
		if(count== times):
			_pass(disp)
		else:
			_fail(_get_fail_msg_including_emitted_signals(disp, object))

# ------------------------------------------------------------------------------
# Assert that the passed in object has the specified signal
# ------------------------------------------------------------------------------
func assert_has_signal(object, signal_name, text=""):
	var disp = str('Expected object ', object, ' to have signal [', signal_name, ']:  ', text)
	if(_signal_watcher.does_object_have_signal(object, signal_name)):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Returns the number of times a signal was emitted.  -1 returned if the object
# is not being watched.
# ------------------------------------------------------------------------------
func get_signal_emit_count(object, signal_name):
	return _signal_watcher.get_emit_count(object, signal_name)

# ------------------------------------------------------------------------------
# Get the parmaters of a fired signal.  If the signal was not fired null is
# returned.  You can specify an optional index (use get_signal_emit_count to
# determine the number of times it was emitted).  The default index is the
# latest time the signal was fired (size() -1 insetead of 0).  The parameters
# returned are in an array.
# ------------------------------------------------------------------------------
func get_signal_parameters(object, signal_name, index=-1):
	return _signal_watcher.get_signal_parameters(object, signal_name, index)

# ------------------------------------------------------------------------------
# Get the parameters for a method call to a doubled object.  By default it will
# return the most recent call.  You can optionally specify an index.
#
# Returns:
# * an array of parameter values if a call the method was found
# * null when a call to the method was not found or the index specified was
#   invalid.
# ------------------------------------------------------------------------------
func get_call_parameters(object, method_name, index=-1):
	var to_return = null
	if(_utils.is_double(object)):
		to_return = gut.get_spy().get_call_parameters(object, method_name, index)
	else:
		_lgr.error('You must pass a doulbed object to get_call_parameters.')

	return to_return

# ------------------------------------------------------------------------------
# Assert that object is an instance of a_class
# ------------------------------------------------------------------------------
func assert_extends(object, a_class, text=''):
	_lgr.deprecated('assert_extends', 'assert_is')
	assert_is(object, a_class, text)

# Alias for assert_extends
func assert_is(object, a_class, text=''):
	var disp = str('Expected [', object, '] to be type of [', a_class, ']: ', text)
	var NATIVE_CLASS = 'GDScriptNativeClass'
	var GDSCRIPT_CLASS = 'GDScript'
	var bad_param_2 = 'Parameter 2 must be a Class (like Node2D or Label).  You passed '

	if(typeof(object) != TYPE_OBJECT):
		_fail(str('Parameter 1 must be an instance of an object.  You passed:  ', types[typeof(object)]))
	elif(typeof(a_class) != TYPE_OBJECT):
		_fail(str(bad_param_2, types[typeof(a_class)]))
	else:
		disp = str('Expected [', object.get_class(), '] to extend [', a_class.get_class(), ']: ', text)
		if(a_class.get_class() != NATIVE_CLASS and a_class.get_class() != GDSCRIPT_CLASS):
			_fail(str(bad_param_2, a_class.get_class(), '  ', types[typeof(a_class)]))
		else:
			if(object is a_class):
				_pass(disp)
			else:
				_fail(disp)


# ------------------------------------------------------------------------------
# Assert that text contains given search string.
# The match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_contains(text, search, match_case=true):
	var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
	var disp = 'Expected \'%s\' to contain \'%s\', match_case=%s' % [text, search, match_case]
	if(text == '' or search == ''):
		_fail(empty_search % [text, search])
	elif(match_case):
		if(text.find(search) == -1):
			_fail(disp)
		else:
			_pass(disp)
	else:
		if(text.to_lower().find(search.to_lower()) == -1):
			_fail(disp)
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Assert that text starts with given search string.
# match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_starts_with(text, search, match_case=true):
	var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
	var disp = 'Expected \'%s\' to start with \'%s\', match_case=%s' % [text, search, match_case]
	if(text == '' or search == ''):
		_fail(empty_search % [text, search])
	elif(match_case):
		if(text.find(search) == 0):
			_pass(disp)
		else:
			_fail(disp)
	else:
		if(text.to_lower().find(search.to_lower()) == 0):
			_pass(disp)
		else:
			_fail(disp)

# ------------------------------------------------------------------------------
# Assert that text ends with given search string.
# match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_ends_with(text, search, match_case=true):
	var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
	var disp = 'Expected \'%s\' to end with \'%s\', match_case=%s' % [text, search, match_case]
	var required_index = len(text) - len(search)
	if(text == '' or search == ''):
		_fail(empty_search % [text, search])
	elif(match_case):
		if(text.find(search) == required_index):
			_pass(disp)
		else:
			_fail(disp)
	else:
		if(text.to_lower().find(search.to_lower()) == required_index):
			_pass(disp)
		else:
			_fail(disp)

# ------------------------------------------------------------------------------
# Assert that a method was called on an instance of a doubled class.  If
# parameters are supplied then the params passed in when called must match.
# TODO make 3rd parameter "param_or_text" and add fourth parameter of "text" and
#      then work some magic so this can have a "text" parameter without being
#      annoying.
# ------------------------------------------------------------------------------
func assert_called(inst, method_name, parameters=null):
	var disp = str('Expected [',method_name,'] to have been called on ',inst)

	if(_fail_if_parameters_not_array(parameters)):
		return

	if(!_utils.is_double(inst)):
		_fail('You must pass a doubled instance to assert_called.  Check the wiki for info on using double.')
	else:
		if(gut.get_spy().was_called(inst, method_name, parameters)):
			_pass(disp)
		else:
			if(parameters != null):
				disp += str(' with parameters ', parameters)
			_fail(str(disp, "\n", _get_desc_of_calls_to_instance(inst)))

# ------------------------------------------------------------------------------
# Assert that a method was not called on an instance of a doubled class.  If
# parameters are specified then this will only fail if it finds a call that was
# sent matching parameters.
# ------------------------------------------------------------------------------
func assert_not_called(inst, method_name, parameters=null):
	var disp = str('Expected [', method_name, '] to NOT have been called on ', inst)

	if(_fail_if_parameters_not_array(parameters)):
		return

	if(!_utils.is_double(inst)):
		_fail('You must pass a doubled instance to assert_not_called.  Check the wiki for info on using double.')
	else:
		if(gut.get_spy().was_called(inst, method_name, parameters)):
			if(parameters != null):
				disp += str(' with parameters ', parameters)
			_fail(str(disp, "\n", _get_desc_of_calls_to_instance(inst)))
		else:
			_pass(disp)

# ------------------------------------------------------------------------------
# Assert that a method on an instance of a doubled class was called a number
# of times.  If parameters are specified then only calls with matching
# parameter values will be counted.
# ------------------------------------------------------------------------------
func assert_call_count(inst, method_name, expected_count, parameters=null):
	var count = gut.get_spy().call_count(inst, method_name, parameters)

	if(_fail_if_parameters_not_array(parameters)):
		return

	var param_text = ''
	if(parameters):
		param_text = ' with parameters ' + str(parameters)
	var disp = 'Expected [%s] on %s to be called [%s] times%s.  It was called [%s] times.'
	disp = disp % [method_name, inst, expected_count, param_text, count]

	if(!_utils.is_double(inst)):
		_fail('You must pass a doubled instance to assert_call_count.  Check the wiki for info on using double.')
	else:
		if(count == expected_count):
			_pass(disp)
		else:
			_fail(str(disp, "\n", _get_desc_of_calls_to_instance(inst)))

# ------------------------------------------------------------------------------
# Asserts the passed in value is null
# ------------------------------------------------------------------------------
func assert_null(got, text=''):
	var disp = str('Expected [', got, '] to be NULL:  ', text)
	if(got == null):
		_pass(disp)
	else:
		_fail(disp)

# ------------------------------------------------------------------------------
# Asserts the passed in value is null
# ------------------------------------------------------------------------------
func assert_not_null(got, text=''):
	var disp = str('Expected [', got, '] to be anything but NULL:  ', text)
	if(got == null):
		_fail(disp)
	else:
		_pass(disp)

# -----------------------------------------------------------------------------
# Asserts object has been freed from memory
# We pass in a title (since if it is freed, we lost all identity data)
# -----------------------------------------------------------------------------
func assert_freed(obj, title):
	assert_true(not is_instance_valid(obj), "Object %s is freed" % title)

# ------------------------------------------------------------------------------
# Asserts Object has not been freed from memory
# -----------------------------------------------------------------------------
func assert_not_freed(obj, title):
	assert_true(is_instance_valid(obj), "Object %s is not freed" % title)

# ------------------------------------------------------------------------------
# Mark the current test as pending.
# ------------------------------------------------------------------------------
func pending(text=""):
	_summary.pending += 1
	if(gut):
		if(text == ""):
			gut.p("Pending")
		else:
			gut.p("Pending:  " + text)
		gut._pending(text)

# ------------------------------------------------------------------------------
# Returns the number of times a signal was emitted.  -1 returned if the object
# is not being watched.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Yield for the time sent in.  The optional message will be printed when
# Gut detects the yield.  When the time expires the YIELD signal will be
# emitted.
# ------------------------------------------------------------------------------
func yield_for(time, msg=''):
	return gut.set_yield_time(time, msg)

# ------------------------------------------------------------------------------
# Yield to a signal or a maximum amount of time, whichever comes first.  When
# the conditions are met the YIELD signal will be emitted.
# ------------------------------------------------------------------------------
func yield_to(obj, signal_name, max_wait, msg=''):
	watch_signals(obj)
	gut.set_yield_signal_or_time(obj, signal_name, max_wait, msg)

	return gut

# ------------------------------------------------------------------------------
# Ends a test that had a yield in it.  You only need to use this if you do
# not make assertions after a yield.
# ------------------------------------------------------------------------------
func end_test():
	_lgr.deprecated('end_test is no longer necessary, you can remove it.')
	#gut.end_yielded_test()

func get_summary():
	return _summary

func get_fail_count():
	return _summary.failed

func get_pass_count():
	return _summary.passed

func get_pending_count():
	return _summary.pending

func get_assert_count():
	return _summary.asserts

func clear_signal_watcher():
	_signal_watcher.clear()

func get_double_strategy():
	return gut.get_doubler().get_strategy()

func set_double_strategy(double_strategy):
	gut.get_doubler().set_strategy(double_strategy)

func pause_before_teardown():
	gut.pause_before_teardown()
# ------------------------------------------------------------------------------
# Convert the _summary dictionary into text
# ------------------------------------------------------------------------------
func get_summary_text():
	var to_return = get_script().get_path() + "\n"
	to_return += str('  ', _summary.passed, ' of ', _summary.asserts, ' passed.')
	if(_summary.pending > 0):
		to_return += str("\n  ", _summary.pending, ' pending')
	if(_summary.failed > 0):
		to_return += str("\n  ", _summary.failed, ' failed.')
	return to_return

# ------------------------------------------------------------------------------
# Double a script, inner class, or scene using a path or a loaded script/scene.
#
#
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _smart_double(double_info):
	var override_strat = _utils.nvl(double_info.strategy, gut.get_doubler().get_strategy())
	var to_return = null

	if(double_info.is_scene()):
		if(double_info.make_partial):
			to_return =  gut.get_doubler().partial_double_scene(double_info.path, override_strat)
		else:
			to_return =  gut.get_doubler().double_scene(double_info.path, override_strat)

	elif(double_info.is_native()):
		if(double_info.make_partial):
			to_return = gut.get_doubler().partial_double_gdnative(double_info.path)
		else:
			to_return = gut.get_doubler().double_gdnative(double_info.path)

	elif(double_info.is_script()):
		if(double_info.subpath == null):
			if(double_info.make_partial):
				to_return = gut.get_doubler().partial_double(double_info.path, override_strat)
			else:
				to_return = gut.get_doubler().double(double_info.path, override_strat)
		else:
			if(double_info.make_partial):
				to_return = gut.get_doubler().partial_double_inner(double_info.path, double_info.subpath, override_strat)
			else:
				to_return = gut.get_doubler().double_inner(double_info.path, double_info.subpath, override_strat)
	return to_return

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func double(thing, p2=null, p3=null):
	var double_info = DoubleInfo.new(thing, p2, p3)
	double_info.make_partial = false

	return _smart_double(double_info)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func partial_double(thing, p2=null, p3=null):
	var double_info = DoubleInfo.new(thing, p2, p3)
	double_info.make_partial = true

	return _smart_double(double_info)


# ------------------------------------------------------------------------------
# Specifically double a scene
# ------------------------------------------------------------------------------
func double_scene(path, strategy=null):
	var override_strat = _utils.nvl(strategy, gut.get_doubler().get_strategy())
	return gut.get_doubler().double_scene(path, override_strat)

# ------------------------------------------------------------------------------
# Specifically double a script
# ------------------------------------------------------------------------------
func double_script(path, strategy=null):
	var override_strat = _utils.nvl(strategy, gut.get_doubler().get_strategy())
	return gut.get_doubler().double(path, override_strat)

# ------------------------------------------------------------------------------
# Specifically double an Inner class in a a script
# ------------------------------------------------------------------------------
func double_inner(path, subpath, strategy=null):
	var override_strat = _utils.nvl(strategy, gut.get_doubler().get_strategy())
	return gut.get_doubler().double_inner(path, subpath, override_strat)

# ------------------------------------------------------------------------------
# Add a method that the doubler will ignore.  You can pass this the path to a
# script or scene or a loaded script or scene.  When running tests, these
# ignores are cleared after every test.
# ------------------------------------------------------------------------------
func ignore_method_when_doubling(thing, method_name):
	var double_info = DoubleInfo.new(thing)
	var path = double_info.path

	if(double_info.is_scene()):
		var inst = thing.instantiate()
		if(inst.get_script()):
			path = inst.get_script().get_path()

	gut.get_doubler().add_ignored_method(path, method_name)

# ------------------------------------------------------------------------------
# Stub something.
#
# Parameters
# 1: the thing to stub, a file path or a instance or a class
# 2: either an inner class subpath or the method name
# 3: the method name if an inner class subpath was specified
# NOTE:  right now we cannot stub inner classes at the path level so this should
#        only be called with two parameters.  I did the work though so I'm going
#        to leave it but not update the wiki.
# ------------------------------------------------------------------------------
func stub(thing, p2, p3=null):
	var method_name = p2
	var subpath = null
	if(p3 != null):
		subpath = p2
		method_name = p3
	var sp = _utils.StubParams.new(thing, method_name, subpath)
	gut.get_stubber().add_stub(sp)
	return sp

# ------------------------------------------------------------------------------
# convenience wrapper.
# ------------------------------------------------------------------------------
func simulate(obj, times, delta):
	gut.simulate(obj, times, delta)

# ------------------------------------------------------------------------------
# Replace the node at base_node.get_node(path) with with_this.  All references
# to the node via $ and get_node(...) will now return with_this.  with_this will
# get all the groups that the node that was replaced had.
#
# The node that was replaced is queued to be freed.
# ------------------------------------------------------------------------------
func replace_node(base_node, path_or_node, with_this):
	var path = path_or_node

	if(typeof(path_or_node) != TYPE_STRING):
		# This will cause an engine error if it fails.  It always returns a
		# NodePath, even if it fails.  Checking the name count is the only way
		# I found to check if it found something or not (after it worked I
		# didn't look any farther).
		path = base_node.get_path_to(path_or_node)
		if(path.get_name_count() == 0):
			_lgr.error('You passed an object that base_node does not have.  Cannot replace node.')
			return

	if(!base_node.has_node(path)):
		_lgr.error(str('Could not find node at path [', path, ']'))
		return

	var to_replace = base_node.get_node(path)
	var parent = to_replace.get_parent()
	var replace_name = to_replace.get_name()

	parent.remove_child(to_replace)
	parent.add_child(with_this)
	with_this.set_name(replace_name)
	with_this.set_owner(parent)

	var groups = to_replace.get_groups()
	for i in range(groups.size()):
		with_this.add_to_group(groups[i])

	to_replace.queue_free()
# ------------------------------------------------------------------------------
# Used to keep track of info about each test ran.
# ------------------------------------------------------------------------------
class Test:
	# indicator if it passed or not.  defaults to true since it takes only
	# one failure to make it not pass.  _fail in gut will set this.
	var passed = true
	# the name of the function
	var name = ""
	# flag to know if the name has been printed yet.
	var has_printed_name = false
	# the line number the test is on
	var line_number = -1

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
class TestScript:
	var inner_class_name = null
	var tests = []
	var path = null
	var _utils = null
	var _lgr = null

	func _init(utils=null, logger=null):
		_utils = utils
		_lgr = logger

	func to_s():
		var to_return = path
		if(inner_class_name != null):
			to_return += str('.', inner_class_name)
		to_return += "\n"
		for i in range(tests.size()):
			to_return += str('  ', tests[i].name, "\n")
		return to_return

	func get_new():
		var TheScript = load(path)
		var inst = null
		if(inner_class_name != null):
			inst = TheScript.get(inner_class_name).new()
		else:
			inst = TheScript.new()
		return inst

	func get_full_name():
		var to_return = path
		if(inner_class_name != null):
			to_return += '.' + inner_class_name
		return to_return

	func get_scene_file_path():
		return path.get_file()

	func has_inner_class():
		return inner_class_name != null

	func export_to(config_file, section):
		config_file.set_value(section, 'path', path)
		config_file.set_value(section, 'inner_class', inner_class_name)
		var names = []
		for i in range(tests.size()):
			names.append(tests[i].name)
		config_file.set_value(section, 'tests', names)

	func _remap_path(path):
		var to_return = path
		if(!_utils.file_exists(path)):
			_lgr.debug('Checking for remap for:  ' + path)
			var remap_path = path.get_basename() + '.gd.remap'
			if(_utils.file_exists(remap_path)):
				var cf = ConfigFile.new()
				cf.load(remap_path)
				to_return = cf.get_value('remap', 'path')
			else:
				_lgr.warn('Could not find remap file ' + remap_path)
		return to_return

	func import_from(config_file, section):
		path = config_file.get_value(section, 'path')
		path = _remap_path(path)
		var test_names = config_file.get_value(section, 'tests')
		for i in range(test_names.size()):
			var t = Test.new()
			t.name = test_names[i]
			tests.append(t)
		# Null is an acceptable value, but you can't pass null as a default to
		# get_value since it thinks you didn't send a default...then it spits
		# out red text.  This works around that.
		var inner_name = config_file.get_value(section, 'inner_class', 'Placeholder')
		if(inner_name != 'Placeholder'):
			inner_class_name = inner_name
		else: # just being explicit
			inner_class_name = null


# ------------------------------------------------------------------------------
# start test_collector, I don't think I like the name.
# ------------------------------------------------------------------------------
var scripts = []
var _test_prefix = 'test_'
var _test_class_prefix = 'Test'

var _utils = load('res://addons/gut/utils.gd').new()
var _lgr = _utils.get_logger()

func _parse_script(script):
	var file = File.new()
	var line = ""
	var line_count = 0
	var inner_classes = []
	var scripts_found = []

	file.open(script.path, 1)
	while(!file.eof_reached()):
		line_count += 1
		line = file.get_line()
		#Add a test
		if(line.begins_with("func " + _test_prefix)):
			var from = line.find(_test_prefix)
			var line_len = line.find("(") - from
			var new_test = Test.new()
			new_test.name = line.substr(from, line_len)
			new_test.line_number = line_count
			script.tests.append(new_test)

		if(line.begins_with('class ')):
			var iclass_name = line.replace('class ', '')
			iclass_name = iclass_name.replace(':', '')
			if(iclass_name.begins_with(_test_class_prefix)):
				inner_classes.append(iclass_name)

	scripts_found.append(script.path)

	for i in range(inner_classes.size()):
		var ts = TestScript.new(_utils, _lgr)
		ts.path = script.path
		ts.inner_class_name = inner_classes[i]
		if(_parse_inner_class_tests(ts)):
			scripts.append(ts)
			scripts_found.append(script.path + '[' + inner_classes[i] +']')

	file.close()
	return scripts_found

func _parse_inner_class_tests(script):
	var inst = script.get_new()

	if(!inst is _utils.Test):
		_lgr.warn('Ignoring ' + script.inner_class_name + ' because it starts with "' + _test_class_prefix + '" but does not extend addons/gut/test.gd')
		return false

	var methods = inst.get_method_list()
	for i in range(methods.size()):
		var name = methods[i]['name']
		if(name.begins_with(_test_prefix) and methods[i]['flags'] == 65):
			var t = Test.new()
			t.name = name
			script.tests.append(t)

	return true
# -----------------
# Public
# -----------------
func add_script(path):
	# SHORTCIRCUIT
	if(has_script(path)):
		return []

	var f = File.new()
	# SHORTCIRCUIT
	if(!f.file_exists(path)):
		_lgr.error('Could not find script:  ' + path)
		return

	var ts = TestScript.new(_utils, _lgr)
	ts.path = path
	scripts.append(ts)
	return _parse_script(ts)

func to_s():
	var to_return = ''
	for i in range(scripts.size()):
		to_return += scripts[i].to_s() + "\n"
	return to_return
func get_logger():
	return _lgr

func set_logger(logger):
	_lgr = logger

func get_test_prefix():
	return _test_prefix

func set_test_prefix(test_prefix):
	_test_prefix = test_prefix

func get_test_class_prefix():
	return _test_class_prefix

func set_test_class_prefix(test_class_prefix):
	_test_class_prefix = test_class_prefix

func clear():
	scripts.clear()

func has_script(path):
	var found = false
	var idx = 0
	while(idx < scripts.size() and !found):
		if(scripts[idx].path == path):
			found = true
		else:
			idx += 1
	return found

func export_tests(path):
	var success = true
	var f = ConfigFile.new()
	for i in range(scripts.size()):
		scripts[i].export_to(f, str('TestScript-', i))
	var result = f.save(path)
	if(result != OK):
		_lgr.error(str('Could not save exported tests to [', path, '].  Error code:  ', result))
		success = false
	return success

func import_tests(path):
	var success = false
	var f = ConfigFile.new()
	var result = f.load(path)
	if(result != OK):
		_lgr.error(str('Could not load exported tests from [', path, '].  Error code:  ', result))
	else:
		var sections = f.get_sections()
		for key in sections:
			var ts = TestScript.new(_utils, _lgr)
			ts.import_from(f, key)
			scripts.append(ts)
		success = true
	return success
             var things = {}

func get_unique_count():
	return things.size()

func add(thing):
	if(things.has(thing)):
		things[thing] += 1
	else:
		things[thing] = 1

func has(thing):
	return things.has(thing)

func get(thing):
	var to_return = 0
	if(things.has(thing)):
		to_return = things[thing]
	return to_return

func sum():
	var count = 0
	for key in things:
		count += things[key]
	return count

func to_s():
	var to_return = ""
	for key in things:
		to_return += str(key, ":  ", things[key], "\n")
	to_return += str("sum: ", sum())
	return to_return

func get_max_count():
	var max_val = null
	for key in things:
		if(max_val == null or things[key] > max_val):
			max_val = things[key]
	return max_val

func add_array_items(array):
	for i in range(array.size()):
		add(array[i])
         var _Logger = load('res://addons/gut/logger.gd') # everything should use get_logger

var Doubler = load('res://addons/gut/doubler.gd')
var HookScript = load('res://addons/gut/hook_script.gd')
var MethodMaker = load('res://addons/gut/method_maker.gd')
var Spy = load('res://addons/gut/spy.gd')
var Stubber = load('res://addons/gut/stubber.gd')
var StubParams = load('res://addons/gut/stub_params.gd')
var Summary = load('res://addons/gut/summary.gd')
var Test = load('res://addons/gut/test.gd')
var TestCollector = load('res://addons/gut/test_collector.gd')
var ThingCounter = load('res://addons/gut/thing_counter.gd')
var OneToMany = load('res://addons/gut/one_to_many.gd')

const GUT_METADATA = '__gut_metadata_'

enum DOUBLE_STRATEGY{
	FULL,
	PARTIAL
}

var _file_checker = File.new()

func is_version_30():
	var info = Engine.get_version_info()
	return info.major == 3 and info.minor == 0

func is_version_31():
	var info = Engine.get_version_info()
	return info.major == 3 and info.minor == 1

# ------------------------------------------------------------------------------
# Everything should get a logger through this.
#
# Eventually I want to make this get a single instance of a logger but I'm not
# sure how to do that without everything having to be in the tree which I
# DO NOT want to to do.  I'm thinking of writings some instance ids to a file
# and loading them in the _init for this.
# ------------------------------------------------------------------------------
func get_logger():
	return _Logger.new()

# ------------------------------------------------------------------------------
# Returns an array created by splitting the string by the delimiter
# ------------------------------------------------------------------------------
func split_string(to_split, delim):
	var to_return = []

	var loc = to_split.find(delim)
	while(loc != -1):
		to_return.append(to_split.substr(0, loc))
		to_split = to_split.substr(loc + 1, to_split.length() - loc)
		loc = to_split.find(delim)
	to_return.append(to_split)
	return to_return

# ------------------------------------------------------------------------------
# Returns a string containing all the elements in the array separated by delim
# ------------------------------------------------------------------------------
func join_array(a, delim):
	var to_return = ''
	for i in range(a.size()):
		to_return += str(a[i])
		if(i != a.size() -1):
			to_return += str(delim)
	return to_return

# ------------------------------------------------------------------------------
# return if_null if value is null otherwise return value
# ------------------------------------------------------------------------------
func nvl(value, if_null):
	if(value == null):
		return if_null
	else:
		return value

# ------------------------------------------------------------------------------
# returns true if the object has been freed, false if not
#
# From what i've read, the weakref approach should work.  It seems to work most
# of the time but sometimes it does not catch it.  The str comparison seems to
# fill in the gaps.  I've not seen any errors after adding that check.
# ------------------------------------------------------------------------------
func is_freed(obj):
	var wr = weakref(obj)
	return !(wr.get_ref() and str(obj) != '[Deleted Object]')

func is_not_freed(obj):
	return !is_freed(obj)

func is_double(obj):
	return obj.get(GUT_METADATA) != null

func extract_property_from_array(source, property):
	var to_return = []
	for i in (source.size()):
		to_return.append(source[i].get(property))
	return to_return

func file_exists(path):
	return _file_checker.file_exists(path)

func write_file(path, content):
	var f = File.new()
	f.open(path, f.WRITE)
	f.store_string(content)
	f.close()

func is_null_or_empty(text):
	return text == null or text == ''

func get_native_class_name(thing):
	var to_return = null
	if(is_native_class(thing)):
		to_return = thing.new().get_class()
	return to_return

func is_native_class(thing):
	var it_is = false
	if(typeof(thing) == TYPE_OBJECT):
		it_is = str(thing).begins_with("[GDScriptNativeClass:")
	return it_is
   extends Node

@onready var ui = $UI


func _ready() -> void:
	GodotGateway.connect("event", Callable(self, "_on_event"))


func _on_event(e_name, e_data) -> void:
	match e_name:
		_:
			print("Unexpected event name: " + str(e_name))
       RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://src/Main/Main.gd ��������   PackedScene    res://src/UI/UI.tscn ��������      local://PackedScene_a500t ?         PackedScene          	         names "         Main    script    Node    UI    layout_mode    anchors_preset    grow_horizontal    grow_vertical    	   variants                                                  node_count             nodes        ��������       ����                      ���                                           conn_count              conns               node_paths              editable_instances              version             RSRC extends Node

signal event(name, data)

# Structure of the dictionary:
# KEYS: events names
# VARS: array of arrays, with target node and target function
#
# Behaviour:
# On 'event_name' event, the 'func_name' is called on the 'node'
# 	{
#		"event_name": [
#			[ node:Node, func_name:String ],
#			...
#		],
#		...
# 	}
var _event_listeners : Dictionary = {}


func new_event(e_name:String, e_data:String) -> void:
	JS_API.call_function("gatewayToJS.newEvent", [e_name, e_data])


func _call_func(func_name:String):
	return JS_API.call_function("gatewayToGodot." + func_name)


func _ready() -> void:
	GodotGateway.call_deferred("_check_gateways_and_create_ready_event")


func _check_gateways_and_create_ready_event() -> void:
	if not JS_API.variable_exist("gatewayToGodot"):
		push_warning("Gateway to Godot is undefined. Events will not be processed")
		GodotGateway.set_process(false)
		
	if not JS_API.variable_exist("gatewayToJS"):
		push_warning("Gateway to JS is undefined. 'new_event' function will not work")
	else:
		GodotGateway.call_deferred("new_event", "ready", "")


func _process(delta) -> void:
	if GodotGateway._call_func("hasEvent"):
		GodotGateway._process_events()


func _process_events() -> void:
	while GodotGateway._call_func("hasEvent"):
		var e_name = GodotGateway._call_func("getCurrentEventName")
		var e_data = GodotGateway._call_func("getCurrentEventData")
		
		emit_signal("event", e_name, e_data)
		_call_listeners(e_name, e_data)
		
		GodotGateway._call_func("next")
		
	GodotGateway._call_func("clearEventsArray")


func _call_listeners(e_name:String, e_data) -> void:
	if not _event_listeners.has(e_name):
		return
	
	var arr : Array = _event_listeners[e_name] 
	for row in arr:
		var node : Node = row[0]
		var func_name : String = row[1]
		node.call(func_name, e_data)


func add_event_listener(e_name:String, node:Node, func_name:String) -> void:
	if not _event_listeners.has(e_name):
		_event_listeners[e_name] = []
	
	var arr : Array = _event_listeners[e_name] 
	arr.push_back([node, func_name])


func remove_event_listener(e_name:String, node:Node, func_name:String) -> void:
	if not _event_listeners.has(e_name):
		return
	
	var arr : Array = _event_listeners[e_name]
	var i := 0
	for row in arr:
		if row[0] == node:
			if row[1] == func_name:
				arr.remove_at(i)
		
		i += 1


func has_event_listener(e_name:String, node:Node, func_name:String) -> bool:
	if not _event_listeners.has(e_name):
		return false
	
	var arr : Array = _event_listeners[e_name] 
	for row in arr:
		if row[0] == node:
			if row[1] == func_name:
				return true
	
	return false
        extends Node

var _is_available: bool = false


func _init():
	_is_available = OS.has_feature("web")


func eval(js_code:String):
	if is_available():
		return JavaScriptBridge.eval(js_code)
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


func variable_exist(variable:String) -> bool:
	var eval_str = "(typeof " + variable + " !== 'undefined')"
	var eval_return = JS_API.eval(eval_str)
	return eval_return


func is_available():
	return _is_available
           extends Control

@onready var msg_popup : AcceptDialog = $MessagePopup
@onready var msg_text_edit : TextEdit = find_child("MessageTextEdit")


func _ready() -> void:
	GodotGateway.add_event_listener("message", self, "show_message")


func show_message(msg:String) -> void:
	msg_popup.dialog_text = msg
	msg_popup.popup()


func _on_GodotEvent_pressed():
	var msg : String = msg_text_edit.text
	GodotGateway.new_event("message_from_godot", msg)
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://src/UI/UI.gd ��������      local://PackedScene_bb6m4 
         PackedScene          	         names "         UI    layout_mode    anchors_preset    anchor_right    anchor_bottom    script    Control    MessagePopup    AcceptDialog    MarginContainer    offset_bottom %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    CenterContainer    custom_minimum_size    VBoxContainer    Label    text    MessageTextEdit 	   TextEdit    GodotEvent    Button    _on_GodotEvent_pressed    pressed    	   variants                         �?               4C   (   
         �B         
   Message:  
         �A
     HC   B      Call event from Godot       node_count             nodes     d   ��������       ����                                                    ����                	   	   ����               
                                               ����                                ����                          ����                                ����      	                          ����      
                         conn_count             conns                                      node_paths              editable_instances              version             RSRC  extends "res://addons/gut/test.gd"

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


func after_each() -> void:
	GodotGateway._event_listeners.clear()


func test_has_not_listener_by_default() -> void:
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


func test_remove_event_listener() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	GodotGateway.remove_event_listener("test_event", fake_class_inst, "_on_test_event")
	assert_false(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))


func test_not_remove_all_event_listeners() -> void:
	var fake_class_inst = _get_fake_class_inst_connected_to_gateway()
	var other_fake_class = _get_fake_class_inst_connected_to_gateway()
	
	GodotGateway.remove_event_listener("test_event", fake_class_inst, "_on_test_event")
	assert_false(GodotGateway.has_event_listener("test_event", fake_class_inst, "_on_test_event"))
	assert_true(GodotGateway.has_event_listener("test_event", other_fake_class, "_on_test_event"))


func _get_fake_class_inst_connected_to_gateway() -> FakeNode:
	var fake_class_inst = _get_fake_class_inst()
	GodotGateway.add_event_listener("test_event", fake_class_inst, "_on_test_event")
	return fake_class_inst


func _get_fake_class_inst() -> FakeNode:
	return FakeNode.new()

      extends "res://addons/gut/test.gd"

var UI = preload("res://src/UI/UI.tscn")
var ui : Control = null
var msg_popup : Popup = null 


func before_each() -> void:
	ui = UI.instantiate()
	add_child(ui)
	msg_popup = ui.find_child("MessagePopup")


func after_each() -> void:
	GodotGateway.remove_event_listener("message", ui, "show_message")
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
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://addons/gut/gut.gd ��������
   Texture2D    res://addons/gut/icon.png �1A<�}#&      local://PackedScene_y8vc5 C         PackedScene          	         names "         Gut    self_modulate    custom_minimum_size    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script 	   __meta__    _run_on_load    _yield_between_tests    _include_subdirectories    _directory1    _double_strategy    Control    	   variants            �?  �?  �?    
     9D  zC                 �?                            _editor_icon                             res://test/unit             node_count             nodes     %   ��������       ����                                                    	      
               	            
                   conn_count              conns               node_paths              editable_instances              version             RSRC    RSRC                    Environment            ��������                                            d      resource_local_to_scene    resource_name    sky_material    process_mode    radiance_size    script    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction        
   local://1 Q	         local://Environment_ejty2 e	         Sky             Environment                                RSRC               GST2   @   @      ����               @ @        �  RIFF�  WEBPVP8L�  /?��m��4�~X��3���˺����r��
0>�����ݕ�N�#����J�m[m���?$�aj�LO��=�b6��l�m��r�S ��,O��C`f�V��A7Ҫdb7t!mH�,��I�mN���'���	g$i�F�Y�c�o�<�<�nǞF�������}�8#�32@��0�����*_��+�be?A��e#l�rP�I��|��<3fe?��E�Xt�E��e�g�T&E&e�T{ ̢�c�!I��g��L�㙁�I
~����a�h�I����KM�o�@��Wf��
����?sPd&E L>�0�Mo�,r�`��{e���ǁ0F�}-��sA  ���q�B $�¹PW���K?�VOg�-H��N�F�y���)	�0շ� ;u��}���d!n���~�-f�􃓛q~�uSP5{�D�=Z/������5��)#�fO��_r'7�M?`œpm�Op��u���p�%�/����#rŵ�?x�+��A�w1#����%� ��KN.H����a��0A���+��$M�GO������?�������~�q��
��	+?[h�8�����#�lV�O�Gp�#���C������S�x�ړ�� �w�'�eRT��m�M���΍��nSC@s�(��Zg! O���|������poD-�]v�/�B�N�܅�$��܏�m YX��);Q��h���s �:_��	0N7���1�H�`�kx?��@�'�>'�x"S��L�	��
qn�q>�iw�o|��I�[<�y�Q_�|��ι5>0BWE��J��T͟'aX��)�gF��,����#<��%8	���B@y:�s�j�w��$����UK�ͬ����a��_p3���!5{./���K�ӗ�%3{.��}٧�,YL{���#��b�Y�){ǝ' ���;�w��4�m�ӛ�EI,�v���+3Ѩ��L_���L4:<V�e�k���g/��H%�)bI7	B��堳��E$�Ҷ���m"	D�(� tV���$�":={A���S�-e�*�%e�)"Y�~� x�3�|F�~��,ԁ���Te���9E0�2~C@���Te(���-�ے,H�opXo�)�n�VF��+�7�j_�0��U�2�EGղ����u���ecF �}93�3�!`J�o�L�Nb���"�i <����[+xO�teL(r�����΄"��P���`��X<���Uܒ@)H�2>V�G��tMp��7YJ�z�X�e�*r �[r���(��O7�e�2={�|���=��Ap>z�"|�  �e��Ӎ�$Fir�|˙���۾U�[%��|˙{�&/0�p�wQK�f�k%[��>��}�w����y�W{�����78+��^c�P�YةkIo�n��P:<V4j^/:�������cE]uv.lՍ�����b(u�|�r��f5_�݉�~k!@�~ki��d5_��xS>}Q?�{/(�,���n�l @.e�Gܒ�hP1y"��qK���8\ `�l��z=�:�}fBR	Խ�UL��··x@@�. �t��
��Q1y�{=C@	�D0��st�:��h����� �p�99����V�@���!~4�7��J�>��y��鰫�v��t�����8Z<��iߨ^O���B���ݺvv.���ٌ���.��sa�����B��^O�oԃ�q� Լ\ �"�)���=�Q��n��s��F�:���ҡ�;���M���e� W4ʤHG�j�5L��]�r�����b-�"=����ɇX�ۉQo'��x'�eR�+a��d�A�|�k�81�"��4��G=l\sŇ�L��%.�S5����@�ɩ�C���D.h��E��I��S	�7�:_�#�I�rI	�3p�b �[�U5�d�m��]�U�\���k�ٵ�K��ɷx�~��w�׶Vc��U5�  fa�����%%�4$�Tt�h(VFO���@�N����R_�6
<�,�C[��>7�$���2x�^}�V_�y�^e:�QI8�ܰ|O����eRdb��/f�l�a �Yt� �-�� ,���C���{�<vO��@����pg�a��=e�)�=�yS��H8#�'㙽l��W&���"��^6�g����)��pF��� |@�I���0���O���4rͺ;ϼ@x�g^�����5��`|��     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://o8anip1d8avl"
path="res://.godot/imported/icon.png-487276ed1e3a0c39cad0279d744ee560.ctex"
metadata={
"vram_texture": false
}
 [remap]

path="res://.godot/exported/133200997/export-2f0cb05a5e71328ea0af1eb4f93c4e22-GutScene.scn"
           [remap]

path="res://.godot/exported/133200997/export-cf5c0f3eefc21238175e70fce704a2c9-Main.scn"
               [remap]

path="res://.godot/exported/133200997/export-27f512e188e08a58eb1114c3e988d63a-UI.scn"
 [remap]

path="res://.godot/exported/133200997/export-38fb2aac5dc229383fa67c43b4feb490-Gut.scn"
[remap]

path="res://.godot/exported/133200997/export-7cf3fd67ad9f55210191d77b582b8209-default_env.res"
        list=Array[Dictionary]([])
     �PNG

   IHDR   @   @   �iq�   sRGB ���  0IDATx��}pTU����L����W�$�@HA�%"fa��Yw�)��A��Egةf���X�g˱��tQ���Eq�!�|K�@BHH:�t>�;�����1!ݝn�A�_UWw����{λ��sϽO�q汤��X,�q�z�<�q{cG.;��]�_�`9s��|o���:��1�E�V� ~=�	��ݮ����g[N�u�5$M��NI��-
�"(U*��@��"oqdYF�y�x�N�e�2���s����KҦ`L��Z)=,�Z}"
�A�n{�A@%$��R���F@�$m������[��H���"�VoD��v����Kw�d��v	�D�$>	�J��;�<�()P�� �F��
�< �R����&�կ��� ����������%�u̚VLNfڠus2�̚VL�~�>���mOMJ���J'R��������X����׬X�Ϲ虾��6Pq������j���S?�1@gL���±����(�2A�l��h��õm��Nb�l_�U���+����_����p�)9&&e)�0 �2{��������1���@LG�A��+���d�W|x�2-����Fk7�2x��y,_�_��}z��rzy��%n�-]l����L��;
�s���:��1�sL0�ڳ���X����m_]���BJ��im�  �d��I��Pq���N'�����lYz7�����}1�sL��v�UIX���<��Ó3���}���nvk)[����+bj�[���k�������cݮ��4t:= $h�4w:qz|A��٧�XSt�zn{�&��õmQ���+�^�j�*��S��e���o�V,	��q=Y�)hԪ��F5~����h�4 *�T�o��R���z�o)��W�]�Sm銺#�Qm�]�c�����v��JO��?D��B v|z�կ��܈�'�z6?[� ���p�X<-���o%�32����Ρz�>��5�BYX2���ʦ�b��>ǣ������SI,�6���|���iXYQ���U�҅e�9ma��:d`�iO����{��|��~����!+��Ϧ�u�n��7���t>�l捊Z�7�nвta�Z���Ae:��F���g�.~����_y^���K�5��.2�Zt*�{ܔ���G��6�Y����|%�M	���NPV.]��P���3�8g���COTy�� ����AP({�>�"/��g�0��<^��K���V����ϫ�zG�3K��k���t����)�������6���a�5��62Mq����oeJ�R�4�q�%|�� ������z���ä�>���0�T,��ǩ�����"lݰ���<��fT����IrX>� � ��K��q�}4���ʋo�dJ��م�X�sؘ]hfJ�����Ŧ�A�Gm߽�g����YG��X0u$�Y�u*jZl|p������*�Jd~qcR�����λ�.�
�r�4���zپ;��AD�eЪU��R�:��I���@�.��&3}l
o�坃7��ZX��O�� 2v����3��O���j�t	�W�0�n5����#è����%?}����`9۶n���7"!�uf��A�l܈�>��[�2��r��b�O�������gg�E��PyX�Q2-7���ʕ������p��+���~f��;����T	�*�(+q@���f��ϫ����ѓ���a��U�\.��&��}�=dd'�p�l�e@y��
r�����zDA@����9�:��8�Y,�����=�l�֮��F|kM�R��GJK��*�V_k+��P�,N.�9��K~~~�HYY��O��k���Q�����|rss�����1��ILN��~�YDV��-s�lfB֬Y�#.�=�>���G\k֬fB�f3��?��k~���f�IR�lS'�m>²9y���+ �v��y��M;NlF���A���w���w�b���Л�j�d��#T��b���e��[l<��(Z�D�NMC���k|Zi�������Ɗl��@�1��v��Щ�!曣�n��S������<@̠7�w�4X�D<A`�ԑ�ML����jw���c��8��ES��X��������ƤS�~�׾�%n�@��( Zm\�raҩ���x��_���n�n���2&d(�6�,8^o�TcG���3���emv7m6g.w��W�e
�h���|��Wy��~���̽�!c� �ݟO�)|�6#?�%�,O֫9y������w��{r�2e��7Dl �ׇB�2�@���ĬD4J)�&�$
�HԲ��
/�߹�m��<JF'!�>���S��PJ"V5!�A�(��F>SD�ۻ�$�B/>lΞ�.Ϭ�?p�l6h�D��+v�l�+v$Q�B0ūz����aԩh�|9�p����cƄ,��=Z�����������Dc��,P��� $ƩЩ�]��o+�F$p�|uM���8R��L�0�@e'���M�]^��jt*:��)^�N�@�V`�*�js�up��X�n���tt{�t:�����\�]>�n/W�\|q.x��0���D-���T��7G5jzi���[��4�r���Ij������p�=a�G�5���ͺ��S���/��#�B�EA�s�)HO`���U�/QM���cdz
�,�!�(���g�m+<R��?�-`�4^}�#>�<��mp��Op{�,[<��iz^�s�cü-�;���쾱d����xk瞨eH)��x@���h�ɪZNU_��cxx�hƤ�cwzi�p]��Q��cbɽcx��t�����M|�����x�=S�N���
Ͽ�Ee3HL�����gg,���NecG�S_ѠQJf(�Jd�4R�j��6�|�6��s<Q��N0&Ge
��Ʌ��,ᮢ$I�痹�j���Nc���'�N�n�=>|~�G��2�)�D�R U���&ՠ!#1���S�D��Ǘ'��ೃT��E�7��F��(?�����s��F��pC�Z�:�m�p�l-'�j9QU��:��a3@0�*%�#�)&�q�i�H��1�'��vv���q8]t�4����j��t-}IـxY�����C}c��-�"?Z�o�8�4Ⱦ���J]/�v�g���Cȷ2]�.�Ǣ ��Ս�{0
�>/^W7�_�����mV铲�
i���FR��$>��}^��dُ�۵�����%��*C�'�x�d9��v�ߏ � ���ۣ�Wg=N�n�~������/�}�_��M��[���uR�N���(E�	� ������z��~���.m9w����c����
�?���{�    IEND�B`�             �T���ax$   res://addons/gut/source_code_pro.fnt�����)�   res://icon.png�1A<�}#&   res://addons/gut/icon.png���_��   res://default_env.tres����ۍ   res://src/Main/Main.tscn��	�i   res://test/Gut.tscn        ECFG
      application/config/name         GodotJSGateway     application/run/main_scene          res://src/Main/Main.tscn   application/config/features   "         4.2    application/config/icon         res://icon.png     autoload/GodotGateway,      "   *res://src/scripts/GodotGateway.gd     autoload/JS_API$         *res://src/scripts/JS_API.gd   editor_plugins/enabled(   "         res://addons/gut/plugin.cfg 2   rendering/environment/defaults/default_environment          res://default_env.tres  $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         