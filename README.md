# GodotControllerDeadzones
This is a collection of controller deadzone examples for Godot 4.2 supporting analog input (Joystick/Thumbstick).
Just start the project and grab your controller/keyboard.

## Usage
```
LB/Q: Previous Deadzone
RB/E: Next Deadzone
```

## Deadzone Variants

### No Deadzone
GOOD: Almost nothing. 

BAD: Everything. Constant drifting, cardinal movement almost impossible.

### Axial Deadzone (deadzone applied to both axis separately) 
GOOD: All directions will have a max magnitude of 1.0. Cardinal movement is easy for the player. 

BAD: The minimum magnitude is both > 0.0 and not constant depending on the direction the stick is pushed. Very slow movement is not possible.

### Axial Deadzone with scaling 
GOOD: Very slow movement is possible because output is rescaled so movement starts at the deadzone point 

BAD: Diagonal movement is slower than cardinal movement (because the scaling is done for 1.0 max values, but diagonally its less than that)

### Simple Radial Deadzone (cut off magnitudes beneath a threshold) 
GOOD: All directions have a max magnitude of 1.0. 

BAD: Cardinal movements are almost impossible. Very slow movements are impossible.

### Scaled Radial Deadzone 
GOOD: All directions have a max magnitude of 1.0. Very slow movements are possible. 

BAD: Cardinal movements are almost impossible.

### Scaled Radial Deadzone with Angle Restriction
GOOD: All directions have a max magnitude of 1.0. Very slow movements are possible. Cardinal movements are easy to do.

BAD: Almost nothing.

## Disclaimer
This was tested with a XBox One Controller.
