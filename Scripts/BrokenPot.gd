extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if "MeshInstance" in child.get_class():  # Check if the child is a MeshInstance
			var body = RigidBody3D.new()  # Create a new RigidBody3D
			body.name = child.name + "_rigid"  # Appropriately name the RigidBody3D
			add_child(body)  # Add the RigidBody3D as a child of the parent node
			child.get_parent().remove_child(child)  # Remove the MeshInstance3D from its original parent
			body.add_child(child)  # Re-parent the MeshInstance3D under the new RigidBody3D

			# Create a CollisionShape3D and assign a ConvexPolygonShape3D to it
			var collision_shape = CollisionShape3D.new()
			var shape = ConvexPolygonShape3D.new()  # Create the shape
			collision_shape.shape = shape
			body.add_child(collision_shape)  # Add CollisionShape3D to the RigidBody3D

			# Create a PhysicsMaterial3D
			var phys_material = PhysicsMaterial.new()
			phys_material.bounce = 0.5  # Set the bounce property
			phys_material.friction = 1.0  # Set the friction property

			# Assign the PhysicsMaterial3D to the RigidBody3D
			body.physics_material_override = phys_material

			# Set other properties
			body.mass = 1  # Set the mass

			# Adjust the CollisionShape3D to fit the MeshInstance3D
			# You may need to manually adjust or use a tool to fit the shape accurately

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
