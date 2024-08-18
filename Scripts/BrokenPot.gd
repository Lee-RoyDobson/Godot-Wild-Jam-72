extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_physics_components()

func _generate_physics_components() -> void:
	for child in get_children():
		# Check if the child is a MeshInstance3D
		if "MeshInstance3D" in child.get_class(): _generate_phys_component(child)  
			

func _generate_phys_component(child: MeshInstance3D):
	var body = RigidBody3D.new()  # Create a new RigidBody3D
	body.name = "rb_" + child.name  # Appropriately name the RigidBody3D
	add_child(body)  # Add the RigidBody3D as a child of the parent node
	child.get_parent().remove_child(child)  # Remove the MeshInstance3D from its original parent
	body.add_child(child)  # Re-parent the MeshInstance3D under the new RigidBody3D

	# Create a CollisionShape3D and assign a ConvexPolygonShape3D to it
	var collision_shape = CollisionShape3D.new()
	var shape = ConvexPolygonShape3D.new()  # Create the shape
	collision_shape.name = "cs_" + child.name
	collision_shape.shape = shape
	body.add_child(collision_shape)  # Add CollisionShape3D to the RigidBody3D

	# Create a PhysicsMaterial3D
	#var phys_material = PhysicsMaterial.new()
	#phys_material.bounce = 0.5  # Set the bounce property
	#phys_material.friction = 1.0  # Set the friction property

	# Assign the PhysicsMaterial3D to the RigidBody3D
	#body.physics_material_override = phys_material

	# Set other properties
	body.mass = 1  # Set the mass

	child.name = "mesh_" + child.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
