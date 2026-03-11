extends Node
class_name StateMachine

@export var states: Dictionary[String, GDScript]
@export var current_state: String

var state_instances: Dictionary[String, Object] = {}

func changeState(state) -> void:
	var parent = get_parent()
	
	if state and state_instances.get(state):
		if state_instances[current_state].has_method("exit"):
			state_instances[current_state].exit(parent, state)
		
		if state_instances[state].has_method("enter"):
			state_instances[state].enter(parent, current_state)
		
		current_state = state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key: String in states:
		state_instances[key] = states[key].new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent: CharacterBody2D = get_parent()
	var state: Object = state_instances.get(current_state)
	
	if state == null:
		return
	
	if state.has_method("process"):
		changeState(state.process(parent, delta))

func _physics_process(delta: float) -> void:
	var state: Object = state_instances.get(current_state)
	
	if state == null:
		return
	
	if state.has_method("physics_process"):
		changeState(state.physics_process(get_parent(), delta))
