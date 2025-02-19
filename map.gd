extends TileMap

var atlas:Dictionary = {
	"SNAKE_HEAD": Vector2i(3,0),
	"bLeftRight": Vector2i(2,0),
	"bTopDown": Vector2i(0,1), 
	"SNAKE_TAIL": Vector2i(0,0), # tail faces upward
	"cDownRight": Vector2i(1,0),
	"cRightDown": Vector2i(1,0),
	"cTopRight": Vector2i(1,1),
	"cRightTop": Vector2i(1,1),
	"cLeftDown": Vector2i(3,1),
	"cDownLeft": Vector2i(3,1),
	"cTopLeft": Vector2i(3,2),
	"cLeftTop": Vector2i(3,2),
	"animatable": 2,
	"aTail": 1,
	"aHead": 2,
	"aBody": 3,
	"aCorner": 4,

}


var snakeMoving:bool = false;
var head_pos:Vector2i
var tileset_atlas = 0
var map:Array[Vector2i] # provides the map of the tilemap
var SNAKE_COORDS = Vector2i(18,1)
var snake:Array[Vector2i] # Vector2i array, [0] is the head, and from the head to the tail the number gets bigger


func _ready():
	SnakeCoordinator.tilemap = self

	head_pos = local_to_map(to_local(%starting.global_position))
	var starting_snake:Array[Vector2i] = [head_pos, head_pos + Vector2i.LEFT, head_pos + Vector2i.LEFT + Vector2i.LEFT, head_pos + Vector2i.LEFT + Vector2i.LEFT + Vector2i.LEFT, head_pos + Vector2i.LEFT + Vector2i.LEFT + Vector2i.LEFT + Vector2i.LEFT]
	renderSnake(starting_snake)

	map = get_used_cells(0)
	for i in snake:
		map.erase(i)
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("up"):
		SnakeCoordinator.alignCell.emit(Vector2i(1,-2), 3)
	if !snakeMoving:
		if event.is_action_pressed("up"):
			moveSnake(Vector2i.UP)
			pass
		if event.is_action_pressed("down"):
			moveSnake(Vector2i.DOWN)
			pass
		if event.is_action_pressed("left"):

			moveSnake(Vector2i.LEFT)
			pass
		if event.is_action_pressed("right"):
			moveSnake(Vector2i.RIGHT)
			pass
		


func renderSnake(array:Array[Vector2i]): # make sure that array[0] = head 
	
	var hDirection:int = 0;
	if array[0] + Vector2i.LEFT == array[1]:
		hDirection = SnakeCoordinator.direction.RIGHT
	if array[0] + Vector2i.RIGHT == array[1]:
		hDirection = SnakeCoordinator.direction.LEFT
	if array[0] + Vector2i.DOWN == array[1]:
		hDirection = SnakeCoordinator.direction.UP
	if array[0] + Vector2i.UP == array[1]:
		hDirection = SnakeCoordinator.direction.DOWN
	#addSnakeCell(array[0], atlas.SNAKE_HEAD, hDirection) ##head
	aSnakeCell(array[0], atlas.animatable, Vector2i(0,0), atlas.aHead, hDirection)
	
	for i in array.size(): ## BODY
		if i == array.size()-1: break
		if i != 0: # skips the snake's head since it is already made
			"""if array[i] + Vector2i.LEFT == array[i-1]:
				if array[i] + Vector2i.UP == array[i+1]:
					#addSnakeCell(array[i], atlas.cLeftTop) ## from left to up

				if array[i] + Vector2i.DOWN == array[i+1]:
					addSnakeCell(array[i], atlas.cLeftDown) ## from left to down
				if array[i] + Vector2i.RIGHT == array[i+1]:
					addSnakeCell(array[i], atlas.bLeftRight) ## from left to right
			if array[i] + Vector2i.RIGHT == array[i-1]:
				if array[i] + Vector2i.UP == array[i+1]:
					addSnakeCell(array[i], atlas.cRightTop) ## from right to up
				if array[i] + Vector2i.DOWN == array[i+1]:
					addSnakeCell(array[i], atlas.cRightDown) ## from right to down
				if array[i] + Vector2i.LEFT == array[i+1]:
					addSnakeCell(array[i], atlas.bLeftRight) ## from right to left
			if array[i] + Vector2i.UP == array[i-1]:
				if array[i] + Vector2i.LEFT == array[i+1]:
					addSnakeCell(array[i], atlas.cTopLeft) ## from up to left
				if array[i] + Vector2i.RIGHT == array[i+1]:
					addSnakeCell(array[i], atlas.cTopRight) ## from up to right
				if array[i] + Vector2i.DOWN == array[i+1]:
					addSnakeCell(array[i], atlas.bTopDown) ## from top to down
			if array[i] + Vector2i.DOWN == array[i-1]:
				if array[i] + Vector2i.LEFT == array[i+1]:
					addSnakeCell(array[i], atlas.cDownLeft) ## from down to left
				if array[i] + Vector2i.RIGHT == array[i+1]:
					addSnakeCell(array[i], atlas.cDownRight) ## from down to right
				if array[i] + Vector2i.UP == array[i+1]:
					addSnakeCell(array[i], atlas.bTopDown) ## from down to top
			"""
			if SnakeCoordinator.checkIfCorner(array[i], array[i+1], array[i-1]):
				aSnakeCell(array[i], atlas.animatable, Vector2i(0,0),
				atlas.aCorner, SnakeCoordinator.getCornerDirection(array[i], array[i+1], array[i-1]))
				
				pass
			else:
				aSnakeCell(array[i], atlas.animatable, Vector2i(0,0),
				atlas.aBody, SnakeCoordinator.calcDirectionBetweenCells(array[i], array[i-1]))
			# TODO: add code if the snake's body goes topdown instead of leftright
	pass
	
	var tDirection:int = SnakeCoordinator.calcDirectionBetweenCells(array[array.size()-2], array.back())
		
	#addSnakeCell(array.back(), atlas.SNAKE_TAIL, tDirection) # add tail normal
	aSnakeCell(array.back(), atlas.animatable, Vector2i(0,0), atlas.aTail, tDirection)
	snakeMoving = false

	
func addSnakeCell(_pos:Vector2i,
_atlas:Vector2i = SNAKE_COORDS, direction:int = 0, customTail:bool = false): # 1 for left, 2 for up, 3 for right, 4 for down
	if customTail:
		snake.append(_pos)
		set_cell(0, _pos, 2, Vector2i(0,0), 1)
		return
	
	if _atlas == SNAKE_COORDS: # normal code to avoid breaking changes
		snake.append(_pos)
		set_cell(0, _pos, tileset_atlas, SNAKE_COORDS)
	else:
		snake.append(_pos)
		if direction:
			set_cell(0, _pos, 1, _atlas, direction)
		else:
			set_cell(0, _pos, 1, _atlas)
		
func aSnakeCell(_pos:Vector2i, source_id:int, _atlas:Vector2i, scene:int = 0, direction:int = 0):
	if direction:
		SnakeCoordinator.tile_orientation[_pos] = direction
	set_cell(0, _pos, source_id, _atlas, scene)
	#if direction:
		#SnakeCoordinator.alignCell.emit(_pos, direction)
		#SnakeCoordinator.tile_orientation.
	snake.append(_pos)
	pass
	
func gravity():
	
	for i in snake:
		# checks if there is anything under the snake
		if snake.has(i + Vector2i.DOWN):
			continue
		
		if map.has(i + Vector2i.DOWN):

			return
	

	
	var newSnake:Array[Vector2i]
	for i in snake:
		newSnake.append(i + Vector2i.DOWN)
		
	refreshSnake(newSnake)
	pass
	
func refreshSnake(newSnake:Array[Vector2i]): # function for moving snake (not creating, but replacing)
	for i in snake:
		erase_cell(0, i)
	
	snake.clear()
	
	renderSnake(newSnake)
	
	snake = newSnake
	head_pos = snake[0]
	
	map = get_used_cells(0)
	for i in snake:
		map.erase(i)
	
	
	gravity()

	pass
	
func moveSnake(direction:Vector2i):
	# generate instructions as to how to move each cell
	# calls on refreshSnake() to update the snake
	var newSnake:Array[Vector2i] # Vector2i of calculated next positions for the snake
	
	if map.has(snake[0] + direction):
		return
	if snake.has(snake[0] + direction):
		return # make sure that snake doesent run into itself""" # TODO: Implement this again
	
	snakeMoving = true
	
	newSnake.append(snake[0] + direction) # Make sure that newSnake[0] maps to the head of the snake
	
	for i in snake.size():
		if i == 0: 
			continue
		newSnake.insert(i, snake[i-1])
	
	#refreshSnake(newSnake)
	SnakeCoordinator.moveSnake(snake, newSnake)
	pass
	
