extends Node

##This loader not need connect to node tree for work
##you must call update to check 

enum {
	NOT_LOADING,
	WAIT_LOAD,
	LOAD_COMPLETE,
	ERROR
}

#signal load_completed(path,resource)
#signal load_error(path,error)

var loaders:Dictionary


func loadResource(path:String)->Resource:
	update()
	if loaders.has(path):
		if loaders[path]['state'] == LOAD_COMPLETE:
			return loaders[path]['loader'].get_resource()
		return null	
	loaders[path] = {'loader':ResourceLoader.load_interactive(path),'state':WAIT_LOAD,'progress':0}
	return null
	
func getStatus(path:String)->int:
	if loaders.has(path):
		update()
		return loaders[path]['state']
	return NOT_LOADING
	
func getProgress(path:String)->float:
	if loaders.has(path):
		update()
		return loaders[path]['progress']
	return -1.0;
		
func freeResource(path:String):
	if loaders.has(path):
		loaders.erase(path)
		
func update():
	var err
	for key in loaders.keys():
		err = loaders[key]['loader'].poll()
		if err == ERR_FILE_EOF: # Finished loading.
			loaders[key]['state'] = LOAD_COMPLETE
			loaders[key]['progress'] = 1.0
		else:
			loaders[key]['progress'] = float(loaders[key]['loader'].get_stage()) / loaders[key]['loader'].get_stage_count()
			if err != OK:
				loaders[key]['state'] = ERROR
		
