extends Node

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
#Generates a random rounded point in a cricle of R raduius.
func getRandomPointInCircle(radius):
	var angle = 2 * PI * randf()
	var randomizer = randf() + randf()
	var rounder = randomizer if randomizer < 1 else 2 - randomizer
	return Vector2(round(radius * rounder * cos(angle) + radius), round(radius * rounder * sin(angle) + radius))
#Checks if a Rect2 collides with at least one other Rect2 in an array.
func roomCollidesInArray(room, others):
	for other in others:
		if(other.collidesWith(room)):
			return true
	return false
#Checks if two line segments intersect.
func linesIntersect(line1, line2):
	#Calculate the slope and y-intercetpt of the two lines.
	var m1 = (line1[0].y - line1[1].y) / (line1[0].x - line1[1].x)
	var m2 = (line2[0].y - line2[1].y) / (line2[0].x - line2[1].x) 
	var b1 = line1[0].y - m1 * line1[0].x
	var b2 = line2[0].y - m2 * line2[0].x
	#Calculate the intersection point between two lines.
	var interX = (b2 - b1) / (m1 - m2)
	var intersection = Vector2(interX, m1 * interX + b1)
	#Checks if the intersection point is on both lines.
	return pointInRange(intersection, line1) && pointInRange(intersection, line2)
#Checks is a point is in a range of a line segment.
func pointInRange(point, line):
	#Checks if out of bound OR exactly the same point.
	if(point.x < min(line[0].x, line[1].x) || point.x > max(line[0].x, line[1].x) ||
	   point.y < min(line[0].y, line[1].y) || point.y > max(line[0].y, line[1].y) ||
	   point == line[0] || point == line[1]):
		return false
	return true
#Triangulates rooms.
func triangulateRooms(rooms):
	var edges = []
	#Insertion sorts by x value smallest to largest.
	var i = 1
	while(i < rooms.size()):
		var j = i
		while(j > 0 && rooms[j - 1].getMidpoint().x > rooms[j].getMidpoint().x):
			#Swapping the midpoints.
			var temp = rooms[j - 1]
			rooms[j - 1] = rooms[j]
			rooms[j] = temp
			j -= 1
		i += 1
	#Initial triangle.
	edges.append(Vector2(0, 1))
	edges.append(Vector2(0, 2))
	edges.append(Vector2(1, 2))
	var intersects = false
	#For all rooms left after the initial triangle.
	for currentRoom in range(3, rooms.size()):
		#For all rooms before current toom.
		for previousRoom in range(currentRoom):
			intersects = false
			#Connects currentRoom to the previousRoom.
			var currentEdge = [Vector2(rooms[currentRoom].getMidpoint()), Vector2(rooms[previousRoom].getMidpoint())]
			#For all existing edges in the array.
			for edge in range(edges.size()):
				var previousEdge = [Vector2(rooms[edges[edge].x].getMidpoint()), Vector2(rooms[edges[edge].y].getMidpoint())]
				#Checks is the currentEdge intersects with one of the previous eges.
				if(linesIntersect(currentEdge, previousEdge)):
					intersects = true
			#If no intersections were found, add to edges array.
			if(!intersects): 
				edges.append(Vector2(currentRoom, previousRoom))
	return edges

func initMST():
	pass