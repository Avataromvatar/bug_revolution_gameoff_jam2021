extends Node
class_name DataProviderJson

const JsonHelper = preload("res://lib/helper/json/helper_json.gd")
const DictionaryHelper = preload("res://lib/helper/dictionary/helper_dictionary.gd")

var path:String
var saveThenUpdate=true
var isOpen:bool = false
var _dictionary:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(name:String,path:String,saveThenUpdate:bool=true):
	name = name
	self.path = path
	self.saveThenUpdate = saveThenUpdate



func save():
	pass

func open(path:String='')->bool:
	if path.length()>0 :
		self.path = path
		#if isOpen:
			
	_dictionary = JsonHelper.loadFromJson(self.path)
	if JsonHelper.isExists(self.path):
			_dictionary = JsonHelper.loadFromJson(self.path)
			if _dictionary != null:
				return true
	else:
		return true
	return false
	
func close():
	pass

func create():
	pass
	
func update():
	pass

func read():
	pass

func delete():
	pass
