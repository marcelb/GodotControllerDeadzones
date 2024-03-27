extends Node2D

enum DEADZONE_VARIANT { NONE, AXIAL, SCALED_AXIAL, RADIAL, SCALED_RADIAL }

@export var deadzoneVariant:DEADZONE_VARIANT = DEADZONE_VARIANT.NONE
@export var SPEED = 20000
@export var DEAD_ZONE = 0.25

@onready var Actor = $Actor
@onready var ControllerInputUI:ControllerInputUI = $CanvasLayer/ControllerInputUI
@onready var DeadzoneLabel:Label = $CanvasLayer/DeadzoneLabel

func _ready():
	DeadzoneLabel.text = DEADZONE_VARIANT.keys()[deadzoneVariant]

func _input(event):
	if event.is_action_pressed("next"):
		if (deadzoneVariant < DEADZONE_VARIANT.size() - 1):
			deadzoneVariant = deadzoneVariant + 1
		else:
			deadzoneVariant = 0
	if event.is_action_pressed("previous"):
		if (deadzoneVariant > 0):
			deadzoneVariant = deadzoneVariant - 1
		else:
			deadzoneVariant = DEADZONE_VARIANT.size() - 1
			
	DeadzoneLabel.text = DEADZONE_VARIANT.keys()[deadzoneVariant]

func showInUI(realValue: Vector2, deadzoned: Vector2):
	print(DEADZONE_VARIANT.keys()[deadzoneVariant])
	print("raw: ", realValue, " mag: ", realValue.length())
	print("dead: ", deadzoned, " mag: ", deadzoned.length(), "\n")
	ControllerInputUI.updateRealValue(realValue)
	ControllerInputUI.updateDeadzonedValue(deadzoned)

func axialDeadzone(rawVector, deadzone):
	var deadzonedVector = Vector2(rawVector)
	if(absf(deadzonedVector.x) < deadzone): deadzonedVector.x = 0.0
	if(absf(deadzonedVector.y) < deadzone): deadzonedVector.y = 0.0
	return deadzonedVector

func scaledAxialDeadzone(rawVector, deadzone):
	var rawVectorLength = rawVector.length()
	var deadzonedVector = Vector2(rawVector)
	
	if(absf(deadzonedVector.x) < deadzone): deadzonedVector.x = 0.0
	if(absf(deadzonedVector.y) < deadzone): deadzonedVector.y = 0.0
	
	var direction = deadzonedVector.normalized()
	var magnitude = inverse_lerp(deadzone, 1.0, rawVectorLength)
	
	return direction * magnitude
	
func radialDeadzone(rawVector, deadzone):
	var deadzonedVector = Vector2(rawVector)
	
	if(deadzonedVector.length() <= deadzone):
		return Vector2(0,0)
		
	return deadzonedVector
	
func scaledRadialDeadzone(rawVector, deadzone):
	var deadzonedVector = Vector2(rawVector)
	var magnitude = rawVector.length()
	
	if(magnitude <= deadzone):
		return Vector2(0,0)
		
	deadzonedVector = deadzonedVector.normalized();
	deadzonedVector.x = deadzonedVector.x * inverse_lerp(deadzone, 1.0, magnitude)
	deadzonedVector.y = deadzonedVector.y * inverse_lerp(deadzone, 1.0, magnitude)
	
	return deadzonedVector

func _physics_process(delta):
	var rawVector = Input.get_vector("left", "right", "up", "down", 0.0)
	var deadzonedVector = Vector2()
	
	match(deadzoneVariant):
		DEADZONE_VARIANT.AXIAL: 
			deadzonedVector = axialDeadzone(rawVector, DEAD_ZONE)
		DEADZONE_VARIANT.SCALED_AXIAL: 
			deadzonedVector = scaledAxialDeadzone(rawVector, DEAD_ZONE)
		DEADZONE_VARIANT.RADIAL: 
			deadzonedVector = radialDeadzone(rawVector, DEAD_ZONE)
		DEADZONE_VARIANT.SCALED_RADIAL: 
			deadzonedVector = scaledRadialDeadzone(rawVector, DEAD_ZONE)
		DEADZONE_VARIANT.NONE, _:
			deadzonedVector = rawVector
	
	showInUI(rawVector, deadzonedVector)
	Actor.set_velocity(deadzonedVector * SPEED * delta)
	Actor.move_and_slide()
