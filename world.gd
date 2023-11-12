extends Node2D

func _process(delta):
	if $sound.playing==false:
		$sound.play()
	if $bubbles.playing==false:
		$bubbles.play()
		
	
