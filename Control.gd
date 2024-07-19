extends ColorRect


func _ready():
	for particle_system in get_children():  
		if particle_system is CPUParticles2D:  
			var x = rand_range(65, 150)  # Adjust range as needed
			var y = rand_range(3, 10)  # Adjust range as needed
			particle_system.position.x = x
			particle_system.position.y = y
