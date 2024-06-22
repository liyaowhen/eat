extends Node2D

var tile_position:Vector2i; # postion of this node, dont change it, if you want to move node, delete self then move
@export var orientation:SnakeCoordinator.direction

@export var animationController:AnimationPlayer
@export var sprite:Sprite2D
@export var debugNotes:Label

# required for tail and head
@export var phaseIn:String
@export var phaseOut:String

# required for body (for corners it is a litle weird)
@export var pullDown:String
@export var pullUp:String

@export var rotationOffset:int = 0

func _ready():
	#SnakeCoordinator.phaseIn.connect(_phaseIn)
	SnakeCoordinator.phaseOut.connect(_phaseOut)
	SnakeCoordinator.pullDown.connect(_pullDown)
	SnakeCoordinator.pullUp.connect(_pullUp)
	
	#SnakeCoordinator.alignCell.connect(_alignCell)
	
	if SnakeCoordinator.requestTilePosition(Vector2i(position)):
		tile_position = SnakeCoordinator.requestTilePosition(Vector2i(position))
	SnakeCoordinator.tiles.append(tile_position)

	if tile_position && debugNotes:
		debugNotes.text = str(tile_position)
		
	
	if SnakeCoordinator.tile_orientation.has(tile_position):
		_alignCell(SnakeCoordinator.tile_orientation[tile_position])
		orientation = SnakeCoordinator.tile_orientation[tile_position]
		SnakeCoordinator.tile_orientation.erase(tile_position)
	
	if SnakeCoordinator.toPhaseIn.has(tile_position):
		_phaseIn()
		SnakeCoordinator.toPhaseIn.erase(tile_position)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_orientation():
	if orientation:
		return orientation
	else:
		return "uknown"

func _phaseIn():
	#if pos.has(tile_position):
	animationController.play(phaseIn)
	pass
	
func _phaseOut(pos:Array[Vector2i]):
	if pos.has(tile_position):
		animationController.play(phaseOut)
	pass

func _pullDown(pos:Array[Vector2i]):
	if pos.has(tile_position):
		animationController.play(pullDown)
	pass

func _pullUp(pos:Array[Vector2i]):
	if pos.has(tile_position):
		animationController.play(pullUp)


func _alignCell(direction:int):
	sprite.rotation_degrees = 0;
	if direction == SnakeCoordinator.direction.LEFT:
		sprite.rotation_degrees = -90 + rotationOffset
	if direction == SnakeCoordinator.direction.DOWN:
		sprite.rotation_degrees = -180 + rotationOffset
	if direction == SnakeCoordinator.direction.RIGHT:
		sprite.rotation_degrees = -270 + rotationOffset
	if direction == SnakeCoordinator.direction.UP:
		sprite.rotation_degrees = -360 + rotationOffset


