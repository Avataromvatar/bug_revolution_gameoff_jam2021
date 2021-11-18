extends Node2D

export var gol_scena_key:String = 'lantern'
var gol:GlobalObjectLogic


# Called when the node enters the scene tree for the first time.
func _ready():
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'item'
	gol.event_handlers = {'shoot':funcref(self, '_event_handler_shoot')}
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
