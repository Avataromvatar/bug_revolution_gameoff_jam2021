extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var random_event_on:bool = true
export var random_max_time:float = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	on_random_event(random_event_on,random_max_time)

func on_random_event(on:bool,max_random_time:float = 200):
	random_event_on = on
	random_max_time = max_random_time
	$Timer.stop()
	if on:
		$Timer.start((randf() * max_random_time)+1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if random_event_on:
		var i = randi()%2
		if i == 0:
			$booble1.play()
		else:
			$booble2.play()

func _on_booble1_finished():
	if random_event_on:
		$Timer.start((randf() * random_max_time)+1)


func _on_booble2_finished():
	if random_event_on:
		$Timer.start((randf() * random_max_time)+1)
