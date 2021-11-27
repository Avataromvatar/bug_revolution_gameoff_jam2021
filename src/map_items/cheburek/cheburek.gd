extends Node2D

var id:int =0
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("rotation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.has_method('collisionEvent'):
		body.collisionEvent('cheburec',id)

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("rotation")
