extends Button

var direction

func _ready():
	direction = SnakeCoordinator.tilemap.snake.find(get_parent().tile_position)
	print(direction)
	tooltip_text = str(direction)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = SnakeCoordinator.tilemap.snake.find(get_parent().tile_position)
	tooltip_text = str(direction)
	pass
