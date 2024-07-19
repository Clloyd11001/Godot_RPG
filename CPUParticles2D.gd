extends CPUParticles2D

var twinkling_interval_min = 0.05
var twinkling_interval_max = 0.2

var next_twinkle_time

func _ready():
	# Start the twinkling effect
	start_twinkling()

func start_twinkling():
	# Toggle emission initially
	toggle_emission()
	# Calculate next twinkling time
	next_twinkle_time = rand_range(twinkling_interval_min, twinkling_interval_max)

func _process(delta):
	# Check if next_twinkle_time is initialized
	if next_twinkle_time != null:
		# Update next twinkling time
		next_twinkle_time -= delta
		# Check if it's time to toggle emission
		if next_twinkle_time <= 0.0:
			toggle_emission()
			# Calculate next twinkling time with some randomness
			next_twinkle_time = rand_range(twinkling_interval_min, twinkling_interval_max)

func toggle_emission():
	# Toggle emission
	emitting = !emitting

	# Add a random delay before calculating next twinkling time
	if next_twinkle_time != null:
		next_twinkle_time -= rand_range(0.05, 0.1)  # Adjust range as needed


