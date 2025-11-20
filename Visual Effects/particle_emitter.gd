class_name ParticleEmitter extends Resource

@export var particle_color : Color

const PARTICLE_EMISSION = preload("uid://b5y5jhvimg561")

func emit(parent_node : Node2D):
	var emitted_particles = PARTICLE_EMISSION.instantiate() as CPUParticles2D
	emitted_particles.emitting = true
	emitted_particles.modulate = particle_color
	parent_node.add_child(emitted_particles)
	await emitted_particles.finished
	emitted_particles.queue_free()
