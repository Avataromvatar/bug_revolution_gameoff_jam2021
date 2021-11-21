extends RichTextLabel

signal end_write()
#export var need_write_text:String = 'Hi\nI text writer'
#symbole per second. 0 mean what next symbole after sound effect
#export var height:float = 100
#export var width:float = 100
export var speed_text:float = 0
export var sound_on:bool = true
export var enter_on:bool = true

var nextFirstSymbole:bool = true
var isBBCode:bool = false
var beginBBCode:bool = false

var _text:String
var _count:int =0
var _pause:bool = false

var _time_count:float =0
# Called when the node enters the scene tree for the first time.
func _ready():
	#rect_size = Vector2(width,height)
	set_process(false)
	#start_write_text('Hi\nI a [wave]text writer[/wave]\nAnd be happy',true)

func start_write_text(need_text:String,BBCodeOn:bool = false):
	isBBCode = BBCodeOn
	bbcode_enabled = isBBCode 
	nextFirstSymbole = true
	_text = need_text
	_pause = false
	_count =0
	_time_count = 0
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !_pause:
		if _count<_text.length():
			_next()
		else:
			emit_signal("end_write")
			set_process(false)
	else:
		if speed_text >0:
			_time_count+=delta
			if _time_count>=speed_text:
				_time_count = 0
				_pause = false

func _next():
	_pause = true
	var c = _text[_count]
	_count+=1
	if isBBCode:
		bbcode_text += c
	else:
		text +=c 
	if c != ' ' and c!='\r' and c!='\n' and c!='[': 
		if nextFirstSymbole:
			if sound_on:
				$first_symbol.play()
			elif speed_text==0:
				_pause = false
		else:
			if sound_on:
				$other_symbol.play()
			elif speed_text==0:
				_pause = false
	else:
		nextFirstSymbole = true
		if c == ' ':
			if sound_on:
				$space.play()
			elif speed_text==0:
				_pause = false
			
		if c=='\r' or c=='\n':
			if enter_on:
				if sound_on:
					$next_string.play()
				elif speed_text==0:
					_pause = false
			else:
				if sound_on:
					$space.play()
				elif speed_text==0:
					_pause = false
				#_pause = false
		if c=='[':
			while 1:
				if isBBCode:
					bbcode_text += _text[_count]
				else:
					text +=_text[_count]
				_count+=1
				if _text[_count-1] == ']':
					_pause = false
					break


func _on_first_symbol_finished():
	if speed_text ==0:
		_pause = false


func _on_other_symbol_finished():
	if speed_text ==0:
		_pause = false


func _on_space_finished():
	if speed_text ==0:
		_pause = false


func _on_next_string_finished():
	if speed_text ==0:
		_pause = false
