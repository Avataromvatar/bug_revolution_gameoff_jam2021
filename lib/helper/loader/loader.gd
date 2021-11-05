extends Node

##This loader need connect to node tree for work
##becose he use _process for update progress

signal progress_load_change(progress)
signal load_completed(resource)
signal load_error(error)

var isComplited = false
var loader:ResourceInteractiveLoader = null
#var isLoad:bool =false
var last_progress:float =0
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func loadResource(path:String) -> bool:
#	print('loadResource',path,' Begin')
	if loader != null and !isComplited:
		return false
	isComplited = false
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		emit_signal("load_error",0xFFFF)
		return false
	last_progress = 0
	set_process(true)
	return true

#func getResource()->Resource:
#	if loader!=null and isLoad:
#		var ret = loader.get_resource()
#		loader = null
#		isLoad = false
#		return ret
#	return null

func _process(time):
	#if loader == null:
		# no need to process anymore
	#	set_process(false)
	#	emit_signal("load_completed")
	#	return
	# Poll your loader.
	var err = loader.poll()
	if err == ERR_FILE_EOF: # Finished loading.
	#	isLoad = true
		set_process(false)
		#print('loadResource load_completed')
		emit_signal("load_completed",loader.get_resource())
		isComplited = true
	elif err == OK:
		_update_progress()
	else: # Error during loading.
		set_process(false)
		#print('loadResource load_error')
		emit_signal("load_error",err)
		loader = null

func _update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	if last_progress != progress:
		emit_signal("progress_load_change",progress)
		last_progress = progress 
