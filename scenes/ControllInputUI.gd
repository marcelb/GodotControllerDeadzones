class_name ControllerInputUI extends Control

@onready var ValueCircle:TextureRect = $ValueCircle
@onready var RealValue:ColorRect = $ValueCircle/RealValue
@onready var DeadzonedValue:ColorRect = $ValueCircle/DeadzonedValue

func rescaleVectorForDisplay(vector: Vector2) -> Vector2:
	var middlePosition = ValueCircle.size/2
	return (middlePosition) + vector * middlePosition.x

func updateRealValue(vector: Vector2):
	RealValue.position = rescaleVectorForDisplay(vector) - Vector2(RealValue.size/2)
	
func updateDeadzonedValue(vector: Vector2):
	DeadzonedValue.position = rescaleVectorForDisplay(vector) - Vector2(DeadzonedValue.size/2)
	
