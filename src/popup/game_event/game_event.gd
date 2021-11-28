extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jump_to:String=''
var info:String=''
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func send_event(text:String,bbcodeON:bool=false, jump_to:String='',info:String=''):
	popup()
	self.jump_to = jump_to
	if bbcodeON:
		$VBoxContainer/RichTextLabel.bbcode_enabled = true
		$VBoxContainer/RichTextLabel.bbcode_text = text
	else:
		$VBoxContainer/RichTextLabel.text = text
	get_tree().paused = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().paused = false
	if jump_to.length()>0:
		var gscena = find_parent('SCENA')
		var do:GlobalObjectLogicDTO = GlobalObjectLogicDTO.new()
		do.target_type = 'scena'
		do.target_key = gscena.gol_scena_key
		do.action_name = 'change_scena'
		do.data = {'new_scena':jump_to,'info':info}
		GolMaster.gol_send_action(do)
	hide()
