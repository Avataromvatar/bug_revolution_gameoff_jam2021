extends Node
#class_name HelperDictionary
#element key:value
#add all element from source to target. If source.element != target.element when target.element = source.element 
# value_to_target conflict_rule(key_source,value_source,value_target) 
static func add(source:Dictionary,target:Dictionary, conflict_rule:FuncRef=null)->Dictionary:
	for key in source.keys():
		if target.has(key):
			if source[key] is Dictionary:
				add(source[key],target[key],conflict_rule)
			else:
				if conflict_rule != null:
					target[key] = conflict_rule.call_func(key,source[key],target[key])
				else:
					target[key] = source[key]
		else:
			target[key] = source[key]
	return target

#element key:value
#change target.element if he present in source.  
#return true if change element in target
static func change(source:Dictionary,target:Dictionary)->Dictionary:
	for key in source.keys():
		if target.has(key):
			if source[key] is Dictionary:
				change(source[key],target[key])
			else:
				target[key] = source[key]
	return target

static func remove(dict_three:Dictionary,target:Dictionary)->Dictionary:
	for key in dict_three.keys():
		if target.has(key):
			if dict_three[key] is Dictionary:
				remove(dict_three[key],target[key])
			else:
				dict_three.erase(key)
	return target

static func checkKeys(dict_three:Dictionary,target:Dictionary)->bool:
	for key in dict_three.keys():
		if target.has(key):
			if dict_three[key] is Dictionary:
				if !checkKeys(dict_three[key],target[key]):
					return false
		else:
			return false
	return true

