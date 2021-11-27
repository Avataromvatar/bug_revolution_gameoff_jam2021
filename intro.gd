extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$text_frame.start_write_text('In Fraternitatis Chebureks')
	$text_frame.connect("end_write",self,'_next_scena')
	$AnimationPlayer.play("intro")

func _next_scena():
	$RichTextLabel.show()
	yield(get_tree().create_timer(4.0), "timeout")
	get_tree().change_scene("res://main.tscn") 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$background/bug/Light2D.energy += delta/8 
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://main.tscn") 
