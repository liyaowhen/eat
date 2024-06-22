extends Node
# coordinates the animated movement of snake

enum direction {
	ZERO,
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var cornerStates:Dictionary = {
	"upRight": 3,
	"rightUp": 3,
	"leftUp": 1,
	"upLeft": 1,
	"leftDown": 4,
	"downLeft": 4,
	"downRight": 2,
	"rightDown": 2,
}

var tiles:Array[Vector2i]
var phasingDuration = 0.5
var tile_orientation:Dictionary = {} # ex: {Vector2i(0,0): 1}

signal phaseOut(tilePos:Array[Vector2i])
#signal phaseIn(tilePos:Array[Vector2i])
var toPhaseIn:Array = [] # because of synchronization issues, using a checklist is better than signal

signal pullDown(tilePos:Array[Vector2i])
signal pullUp(tilePos:Array[Vector2i])

signal alignCell(tilePos:Vector2i, direction:int) # change the orientation of the cell

var tilemap:TileMap

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
	
func moveSnake(current:Array[Vector2i], next:Array[Vector2i]):
	"""for i in snake:
		erase_cell(0, i)
	
	snake.clear()
	
	renderSnake(newSnake)
	
	snake = newSnake
	head_pos = snake[0]
	
	map = get_used_cells(0)
	for i in snake:
		map.erase(i)""" ### rewrite this from map.gd
	
	var thPhaseOut:Array[Vector2i] = [current.front(), current.back()] # returns the head and the tail
	phaseOut.emit(thPhaseOut)
	
	var thPhaseIn:Array[Vector2i] = [next.back(), next.front()] # returns the new head and tail

	"""tilemap.set_cell(0, thPhaseIn.back(),
			tilemap.atlas.animatable, Vector2i(0,0), tilemap.atlas.aTail)"""
	tilemap.aSnakeCell(thPhaseIn.back(),
		tilemap.atlas.animatable, Vector2i(0,0), tilemap.atlas.aHead,
		calcDirectionBetweenCells(next[0], next[1]))

	"""tilemap.set_cell(0, thPhaseIn.front(),
			tilemap.atlas.animatable, Vector2i(0,0), tilemap.atlas.aHead)"""
	tilemap.aSnakeCell(thPhaseIn.front(), 
		tilemap.atlas.animatable, Vector2i(0,0), tilemap.atlas.aTail,
		calcDirectionBetweenCells(next[next.size()-2], next.back()))

	
	#phaseIn.emit(thPhaseIn)
	toPhaseIn.append(thPhaseIn.back())
	toPhaseIn.append(thPhaseIn.front())
	print("phasing in " + str(thPhaseIn))

	var bPullDown:Array[Vector2i] = []
	for i in current:
		if thPhaseOut.has(i) || thPhaseIn.has(i):
			continue
		if checkIfCorner(i, current[current.find(i)-1], current[current.find(i)+1]):
			if i == next.back():
				bPullDown.append(i)
			continue
		else:
			bPullDown.append(i)
	pullUp.emit(bPullDown)

	# await for all animations to be done before replacing all of them
	await get_tree().create_timer(phasingDuration).timeout
	for i in current:
		tilemap.erase_cell(0,i)
	tilemap.snake.clear()

	tilemap.renderSnake(next)
	
	pass

func calcDirectionBetweenCells(first:Vector2i, next:Vector2i):
	var dir:int;
	var cDir = first - next
	if cDir == Vector2i.LEFT:
		dir = direction.LEFT
	if cDir == Vector2i.RIGHT:
		dir = direction.RIGHT
	if cDir == Vector2i.DOWN:
		dir = direction.DOWN
	if cDir == Vector2i.UP:
		dir = direction.UP
	return dir
	
func checkIfCorner(middle:Vector2i, left:Vector2i, right:Vector2i):
	var isCorner:bool
	var mlDirection:int = calcDirectionBetweenCells(middle, left)
	if mlDirection == direction.LEFT:
		isCorner = calcDirectionBetweenCells(middle, right) != direction.RIGHT
	if mlDirection == direction.RIGHT:
		isCorner = calcDirectionBetweenCells(middle, right) != direction.LEFT
	if mlDirection == direction.UP:
		isCorner = calcDirectionBetweenCells(middle, right) != direction.DOWN
	if mlDirection == direction.DOWN:
		isCorner = calcDirectionBetweenCells(middle, right) != direction.UP
	return isCorner

func getCornerDirection(middle:Vector2i, start:Vector2i, end:Vector2i):
	var _middle:Vector2i = Vector2i(0,0)
	var _start:Vector2i = start - middle
	var _end:Vector2i = end - middle

	var direction:String;

	if _end == Vector2i.UP:
		if _start == Vector2i.RIGHT:
			direction = "upRight"
		if _start == Vector2i.LEFT:
			direction = "upLeft"
	if _end == Vector2i.RIGHT:
		if _start == Vector2i.UP:
			direction = "rightUp"
		if _start == Vector2i.DOWN:
			direction = "rightDown"
	if _end == Vector2i.DOWN:
		if _start == Vector2i.LEFT:
			direction = "downLeft"
		if _start == Vector2i.RIGHT:
			direction = "downRight"
	if _end == Vector2i.LEFT:
		if _start == Vector2i.UP:
			direction = "leftUp"
		if _start == Vector2i.DOWN:
			direction = "leftDown"
	
	return cornerStates[direction]





func _input(event):
	if event.is_action_pressed("left"):
		#print(tiles)
		#phaseIn.emit(tiles)
		pass

func requestTilePosition(globalPos:Vector2i):
	if tilemap:
		return tilemap.local_to_map(globalPos)
		pass


