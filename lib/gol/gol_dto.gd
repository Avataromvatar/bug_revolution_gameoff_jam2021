extends Node
class_name GlobalObjectLogicDTO 

# scena player object
var target_type:String setget _set_target_type, _get_target_type
# scena_key
var target_key:String setget _set_target_key, _get_target_key
# add remove hit  ...
var action_name:String setget _set_action_name, _get_action_name

var source setget _set_source, _get_source
# user data
var data:Dictionary setget _set_data, _get_data
#  
var _msg:Dictionary 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
 
func init(_action_name,type,_target_key,_data,_source):
	action_name = _action_name
	target_type = type
	target_key = _target_key
	source = _source
	data = _data

func toJson()->String:
	return to_json(_msg)

func getDictionary()->Dictionary:
	return _msg

func fromDictionary(dict:Dictionary) -> GlobalObjectLogicDTO:
	if dict.has('target_type') and dict.has('target_key') and dict.has('name') and dict.has('data'):
		#var ret = GlobalObjectLogicDTO.new()
		#ret._msg = dict
		#return ret 
		_msg = dict
		return self
	return null
#->GlobalObjectLogic_DTO
func fromJson(json:String)-> GlobalObjectLogicDTO:
	var tmp = parse_json(json)
	if typeof(tmp) == TYPE_DICTIONARY:
		if tmp.has('target_type') and tmp.has('target_key') and tmp.has('name') and tmp.has('data'):
			#var ret = GlobalObjectLogicDTO.new()
			#ret._msg = tmp
			#return ret
			_msg = tmp
			return self
	return null

func _set_target_type(param1):
   _msg['target_type'] = param1

func _get_target_type():
   return _msg['target_type']

func _get_source():
   return _msg['source']

func _set_source(param1):
	_msg['source'] = param1
   

func _set_target_key(param1):
   _msg['target_key'] = param1

func _get_target_key():
   return _msg['target_key']

func _set_action_name(param1):
   _msg['name'] = param1

func _get_action_name():
   return _msg['name']

func _set_data(param1):
   _msg['data'] = param1

func _get_data():
   return _msg['data']
