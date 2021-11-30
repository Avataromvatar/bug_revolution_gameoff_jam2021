extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state =0
var wind_of_change:float = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$Control/AnimationPlayer.play("RESET")
func start_state1():
	state = 1
	$RichTextLabel2.hide()
	$TextureRect.hide()
	$Control/text_frame.start_write_text('In Fraternitatis Chebureks')
	$Control/text_frame.connect("end_write",self,'_next_scena')
	$Control/AnimationPlayer.play("intro")

func _next_scena():
	$Control/RichTextLabel.show()
	yield(get_tree().create_timer(4.0), "timeout")
	get_tree().change_scene("res://main.tscn") 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state ==0:
		wind_of_change += delta/100
		if wind_of_change>0.8:
			wind_of_change = 0.8
		$TextureRect.modulate = Color(1,1,1,1-wind_of_change)
		if Input.is_action_pressed("ui_cancel"):
			$AudioStreamPlayer.stop()
			_on_AudioStreamPlayer_finished()
	if state ==1:
		$Control/background/bug/Light2D.energy += delta/8 
		if Input.is_action_pressed("ui_cancel"):
			get_tree().change_scene("res://main.tscn") 


func _on_AudioStreamPlayer_finished():
	yield(get_tree().create_timer(1.0), "timeout")
	state = 1
	start_state1()
