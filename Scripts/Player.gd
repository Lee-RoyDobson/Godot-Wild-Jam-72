extends CharacterBody3D
class_name Player

@export var Speed = 5.0
@export var JUMP_VELOCITY = 4.5

@export var Acceleration = 30.0
@export var Decceleration = 40.0
@export var AirAcceleration = 15.0
@export var AirDrag = 3.5

var is_on_controller:bool = false

var Ray_interact:RayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var camera_motion := Vector2.ZERO # New variable to store both mouse and joystick input for camera movement.
var mouse_sens = 0.5 

@onready var camera_pivot: Node3D = $CameraPivot
@onready var audio_dimension_switch = $DimensionSwitch

## Enabling this defaults this level to grant player control over world switchign
@export var player_controls_switch:bool  = false
var world_switcher

func _ready() -> void:
	set_night_mode(false)
	if Ray_interact == null:
		Ray_interact = $CameraPivot/SubViewportContainer/SubViewport/SmoothCamera/InteractionLine
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#controller shite
	Input.joy_connection_changed.connect(update_interaction_text)
	
	set_defautl_control()

func set_defautl_control():
	world_switcher = WorldSwitcher
	world_switcher.set_player_control(player_controls_switch)

func _physics_process(delta):
	handle_camera_rotation(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handles interaction signaling
	if Input.is_action_just_pressed("action_interact"):
		Ray_interact.force_raycast_update()
		if(Ray_interact.is_colliding()):
			var Collider:Node3D = Ray_interact.get_collider()
			print(Collider.name)
			var tt:Interact_Node = Collider.get_parent() as Interact_Node
			if(tt != null):
				tt.Interact()
				
	var interaction_vis:bool = false
	if Ray_interact.is_colliding(): 
		if Ray_interact.get_collider().get_parent() as Interact_Node:
			interaction_vis = true 
	$CanvasLayer/InteractionText.visible = interaction_vis

	# Handle jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, input_dir.y)).normalized()
	
	#Acceleration and Decceleration
	var onfloor = is_on_floor()
	var acc_val = Acceleration 
	if !is_on_floor(): acc_val = AirAcceleration
	if !direction:
		acc_val = Decceleration
		if !is_on_floor(): acc_val = AirDrag
	
	#convert velocity to 2D plane vector to linearly move it to target velocity
	var flat_vel:Vector2 = Vector2(get_real_velocity().x-get_platform_velocity().x,get_real_velocity().z-get_platform_velocity().z)
	var next_flat_vel = flat_vel.move_toward(Vector2(direction.x * Speed,direction.z * Speed),acc_val*delta)
	velocity = Vector3(next_flat_vel.x, velocity.y, next_flat_vel.y)
	
	#rotate with platform
	if get_platform_angular_velocity().y != 0:
		rotate_y(deg_to_rad(get_platform_angular_velocity().y))
	
	#move player
	if is_on_floor():
		apply_floor_snap()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			# Accumulate mouse motion into camera_motion
			camera_motion -= event.relative * mouse_sens

func _process(delta: float) -> void:
	_controller_rotation(delta)
	
func _controller_rotation(delta: float) -> void:
	var horizontal: float = Input.get_axis("rotate_right", "rotate_left")
	var vertical: float = Input.get_axis("rotate_down", "rotate_up")
	
	if horizontal == 0 and vertical == 0: return # Early exit if both 0
	camera_motion.x += horizontal
	camera_motion.y += vertical 
	
func handle_camera_rotation(delta) -> void:
	# Apply accumulated camera motion
	rotate_y(camera_motion.x * delta)
	camera_pivot.rotate_x(camera_motion.y * delta)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -89.0, 89.0)
	# Reset camera_motion for the next frame
	camera_motion = Vector2.ZERO
	
func set_night_mode(b:bool) -> void:
	$CameraPivot/SubViewportContainer/SubViewport/OpWorldTexture.visible = b

func play_dimension_switch() -> void:
	audio_dimension_switch.play(0)
	
func update_interaction_text(device:int, connected:bool):
	var text_ref:String = "Press E"
	if device == 0 && !connected:
		is_on_controller = false
	else:
		is_on_controller = true
	if is_on_controller:
		text_ref = "Press X"
	$CanvasLayer/InteractionText.text = text_ref
	pass
