extends Node
class_name GlobalObjectLogic

## event from top -> GOL -> action to top
#action from GOL go up to the GOL master and up to the client websocket to server
#From server in client websocket go event/ Event fall down to the GOL Master and to the target gol

#var GlobalObjectLogic_Action = preload("res://lib/gol/gol_action.gd")


export var gol_scena_key:String 
export var gol_type:String
#export var gol_model:Dictionary


##End user must fill this var
var event_handlers:Dictionary


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tree_exited",self,'_tree_exited')
	pass # Replace with function body.


func gol_send_action(action:GlobalObjectLogic_DTO):
	pass

func gol_set_event(event:GlobalObjectLogic_DTO):
	pass



func _tree_exited():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
