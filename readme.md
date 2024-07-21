
## Godot - FPS: Sample Player Controllers

### Simple FPS

- Only supports controller
- Input is processed inside the player controller script


### Input Source + State FPS

- input schemes supported: controller / Keyboard and Mouse
- Input source: abstraction of how the input is handled and calculated
- Player states:
    - each state validates the pre-conditions to be active
    - not much of player movement logic changes per state
    - the state only process the possible axis of movement available on that state



#### State Machine Details

- State Machine:
    - only one state can be active at a time
    - state transition in each state before enter and before exit
