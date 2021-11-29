extends Node
class_name GlobalObjectLogic

## event from top -> GOL -> action to top
#action from GOL go up to the GOL master and up to the client websocket to server
#From server in client websocket go event/ Event fall down to the GOL Master and to the target gol

#var GlobalObjectLogic_DTO1 = preload("res://lib/gol/gol_dto.gd")


export var gol_scena_key:String setget set_new_scena_key
export var gol_type:String
var isRegistred:bool = false
#export var gol_model:Dictionary


##End user must fill this var
##key - action_name value = func what take data
var event_handlers:Dictionary


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func set_new_scena_key(key:String):
	if isRegistred:
		GolMaster.removeGOL(self)
		gol_scena_key=key
		GolMaster.addGOL(self)
	else:
		gol_scena_key=key

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tree_exiting",self,'_tree_exiting')
	GolMaster.addGOL(self)
	isRegistred = true
	

func gol_send_action(action:GlobalObjectLogicDTO):
	GolMaster.gol_send_action(action) 

func gol_set_event(event:GlobalObjectLogicDTO):
	if event_handlers.has(event.action_name):
		event_handlers[event.action_name].call_func(event.data)

func createAction(action:String,data:Dictionary)->GlobalObjectLogicDTO:
	var tmp = GlobalObjectLogicDTO.new()
	tmp.action_name = action
	tmp.target_type = gol_type
	tmp.target_key = gol_scena_key
	tmp.source = gol_scena_key
	tmp.data = data
	return tmp
	
func createActionTo(target_type:String,target_key:String,action:String,data:Dictionary)->GlobalObjectLogicDTO:
	var tmp = GlobalObjectLogicDTO.new()
	tmp.action_name = action
	tmp.target_type = target_type
	tmp.target_key = target_key
	tmp.source = gol_scena_key
	tmp.data = data
	return tmp

func _tree_exiting():
	GolMaster.removeGOL(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
