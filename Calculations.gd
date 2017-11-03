extends Node

func _ready():
	randomize()
#Generates a random rounded point in a cricle of R raduius.
func getRandomPointInCircle(radius):
	var angle = 2 * PI * randf()
	var randomizer = randf() + randf()
	var rounder = randomizer if randomizer < 1 else 2 - randomizer
	return Vector2(round(radius * rounder * cos(angle) + radius), round(radius * rounder * sin(angle) + radius))
#Checks if a Rect2 collides with another.
func roomCollides(room, other):
	return !(room.end.x < other.pos.x || room.pos.x > other.end.x || room.end.y < other.pos.y || room.pos.y > other.end.y)
#Checks if a Rect2 collides with at least one other Rect2 in an array.
func roomCollidesInArray(room, others):
	for other in others:
		if(roomCollides(room, others[other])):
			return true
	return false
#Gets midpoints of all Rect2 in dictionary.
func getMidPoints(rooms):
	var midpoints = []
	for room in rooms:
		midpoints.append(Vector2(rooms[room].pos.x + rooms[room].size.x / 2, rooms[room].pos.y + rooms[room].size.y / 2))
	return midpoints
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
	var midpoints = getMidPoints(rooms)
	var newRooms = dictionaryToArray(rooms)
	#Insertion sorts by x value smallest to largest.
	var i = 1
	while(i < midpoints.size()):
		var j = i
		while(j > 0 && midpoints[j - 1].x > midpoints[j].x):
			#Swapping the midpoints.
			var temp = midpoints[j - 1]
			midpoints[j - 1] = midpoints[j]
			midpoints[j] = temp
			#Swapping the rooms.
			temp = newRooms[j - 1]
			newRooms[j - 1] = newRooms[j]
			newRooms[j] = temp
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
			var currentEdge = [Vector2(midpoints[currentRoom]), Vector2(midpoints[previousRoom])]
			#For all existing edges in the array.
			for edge in range(edges.size()):
				var previousEdge = [Vector2(midpoints[edges[edge].x]), Vector2(midpoints[edges[edge].y])]
				#Checks is the currentEdge intersects with one of the previous eges.
				if(linesIntersect(currentEdge, previousEdge)):
					intersects = true
			#If no intersections were found, add to edges array.
			if(!intersects): 
				edges.append(Vector2(currentRoom, previousRoom))
	#Translate sorted edges to room ids.
	for i in range(edges.size()):
		edges[i] = Vector2(newRooms[edges[i].x][0], newRooms[edges[i].y][0])
	return edges

func initMST():
	pass

func dictionaryToArray(dict):
	var newArray = []
	for key in dict:
		newArray.append([str(key), dict[key]])
	return newArray