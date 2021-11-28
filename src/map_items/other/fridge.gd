extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var cheburec_generated_on:bool = true
export var min_pause:float = 100
export var rand_pause:float = 200
export var posX:float =0
export var posY:float =-20


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_start()
	
func gen_cheburek(on:bool):
	cheburec_generated_on = on
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _start():
	if cheburec_generated_on:
		$Timer.stop()
		$Timer.start((randf()*rand_pause+min_pause))

func _on_Timer_timeout():
	var gscena = find_parent('SCENA')
	var do:GlobalObjectLogicDTO = GlobalObjectLogicDTO.new()
	do.target_type = 'scena'
	do.target_key = gscena.gol_scena_key
	do.action_name = 'add'
	do.data = {'type':'cheburec','positionX':global_position.x+posX,'positionY':global_position.y+posY}
	GolMaster.gol_send_action(do)
	_start()
		
