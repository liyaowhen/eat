extends Node2D

var tile_position:Vector2i; # postion of this node, dont change it, if you want to move node, delete self then move
@export var phaseIn:String
@export var phaseOut:String
@export var animationController:AnimationPlayer
@export var sprite:Sprite2D

func _ready():
	SnakeCoordinator.phaseIn.connect(_phaseIn)
	SnakeCoordinator.phaseOut.connect(_phaseOut)
	SnakeCoordinator.alignCell.connect(_alignCell)
	
	tile_position = SnakeCoordinator.requestTilePosition(Vector2i(position))
	SnakeCoordinator.tiles.append(tile_position)
	
	print("im here")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _phaseIn(pos:Array[Vector2i]):
	print(tile_position)
	if pos.has(tile_position):
		animationController.play(phaseIn)
		
		pass
	pass
	
func _phaseOut(pos:Array[Vector2i]):
	print('ee')
	if pos.has(tile_position):
		pass
	pass

func _alignCell(pos:Vector2i, direction:int):
	print(pos)
	print(tile_position)
	if pos == tile_position:
		if direction == SnakeCoordinator.direction.LEFT:
			sprite.rotation_degrees = -90
		if direction == SnakeCoordinator.direction.DOWN:
			sprite.rotation_degrees = -180
		if direction == SnakeCoordinator.direction.RIGHT:
			sprite.rotation_degrees = -270
		if direction == SnakeCoordinator.direction.UP:
			sprite.rotation_degrees = -360


