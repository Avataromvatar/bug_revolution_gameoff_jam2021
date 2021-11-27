extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_resume_pressed():
	self.hide()
	get_tree().paused = false


func _on_exit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://main.tscn") 


func _on_exit_pressed():
	get_tree().quit()
