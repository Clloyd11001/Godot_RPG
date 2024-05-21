extends Label

func update_text(level, experience, required_exp):
	text = """
			Level: %s
			Exp: %s / Next lvl: %s
			""" % [ level, experience, required_exp]

#Level: %s (level)
