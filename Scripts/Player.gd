extends CharacterBody3D
class_name Player

@export var Speed = 5.0
@export var JUMP_VELOCITY = 4.5

@export var Acceleration = 30.0
@export var Decceleration = 40.0
@export var AirAcceleration = 15.0
@export var AirDrag = 3.5

var Ray_interact:RayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var mouse_sens = 1

@onready var camera_pivot: Node3D = $CameraPivot

func _ready() -> void:
	if Ray_interact == null:
		Ray_interact = $CameraPivot/SubViewportContainer/SubViewport/SmoothCamera/InteractionLine
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	handle_camera_rotation()
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

	# Handle jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, input_dir.y)).normalized()
	
	print(input_dir)
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
			mouse_motion = -event.relative * 0.001

func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x*mouse_sens)
	camera_pivot.rotate_x(mouse_motion.y*mouse_sens)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -89.0, 89.0)
	mouse_motion = Vector2.ZERO
