extends Node
class_name GlobalObjectLogic_DTO

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

func init(action_name,type,target_key,data,source):
	self.action_name = action_name
	target_type = type
	self.target_key = target_key
	self.source = source
	self.data = data

func toJson()->String:
	return to_json(_msg)

func getDictionary()->Dictionary:
	return _msg

func fromJson(json:String)->GlobalObjectLogic_DTO:
	var tmp = parse_json(json)
	if typeof(tmp) == TYPE_DICTIONARY:
		if tmp.has('target_type') and tmp.has('target_key') and tmp.has('name') and tmp.has('data'):
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
