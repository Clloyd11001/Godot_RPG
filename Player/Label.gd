extends Label

func update_text(experience, required_exp):
	text = """
			Exp: %s / Next lvl: %s
			""" % [ experience, required_exp]

#Level: %s (level)
