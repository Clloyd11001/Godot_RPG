tool
extends Node

# Define your singleton instance
var instance

func _init():
	# Make sure there's only one instance of the singleton
	if instance == null:
		instance = self
		

# Add any properties or methods you need for location management
var buildingLocations = {}

func setBuildingLocation(buildingName, location):
	buildingLocations[buildingName] = location

func getBuildingLocation(buildingName):
	if buildingName in buildingLocations:
		return buildingLocations[buildingName]
	else:
		return null
