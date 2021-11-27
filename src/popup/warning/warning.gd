extends Popup

export var num_warning_in_pop:int = 3
export var time_close_popup:float = 2 
var warning:Array
var tmr:Timer



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func add_warning(text:String):
	var t = OS.get_time()
	var msec = OS.get_ticks_msec() 
	warning.push_back(str(msec)+': '+text)
	if warning.size()>num_warning_in_pop:
		warning.pop_front()
	_start_view()
	
func _start_view():
	$RichTextLabel.text = ''
	for i in range(warning.size(),0,-1):
		$RichTextLabel.text +=warning[i-1]
		$RichTextLabel.text += '\n'
	self.popup()
	$Timer.start(time_close_popup)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = time_close_popup
	$Timer.autostart = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	self.hide()
	
