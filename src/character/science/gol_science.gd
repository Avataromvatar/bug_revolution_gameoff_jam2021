extends Node2D

export var gol_scena_key:String = 'science'
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Actor.gol_scena_key = gol_scena_key

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
