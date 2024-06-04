extends Node
# coordinates the animated movement of snake

enum direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var tiles:Array[Vector2i]

signal phaseOut(tilePos:Array[Vector2i])
signal phaseIn(tilePos:Array[Vector2i])
signal alignCell(tilePos:Vector2i, direction:int)

var tilemap

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
	
func moveSnake(current:Array[Vector2i], next:Array[Vector2i]):
	pass
	
func _input(event):
	if event.is_action_pressed("left"):
		print(tiles)
		phaseIn.emit(tiles)

func requestTilePosition(globalPos:Vector2i):
	if tilemap:
		return tilemap.local_to_map(globalPos)
		pass


