extends Node
#class_name HelperJson

static func saveToJson(path:String,json:Dictionary)->bool:
	var file = File.new()
	var ret = file.open(path, File.WRITE)
	if(ret ==OK):	
		file.store_string(to_json(json))
		file.close()
		return true
	else:
		printerr('helper_json Error:',ret,' path:',path)
		return false

static func isExists(path:String)->bool:
	var file = File.new()
	if file.file_exists(path):
		return true
	else:
		return false

static func loadFromJson(path:String) ->Dictionary:
	var file = File.new()
	if file.file_exists(path):
		var ret = file.open(path, File.READ)
		if(ret == OK):
			var data = parse_json(file.get_as_text())
			file.close()
			if typeof(data) == TYPE_DICTIONARY:
				return data
		else:
			printerr('helper_json Error:',ret,' path:',path)
			return {}
	else:
		printerr('helper_json Error: file not exists in path:',path)
		printerr("No saved data!")
		return {}
	return {}

