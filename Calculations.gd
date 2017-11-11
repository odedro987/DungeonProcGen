extends Node

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
#Checks if a Rect2 collides with at least one other Rect2 in an array.
func roomCollidesInArray(room, others):
	for other in others:
		if(other.collidesWith(room)):
			return true
	return false
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
			for edge in range(edges.size() - 1, -1, -1):
				var previousEdge = [Vector2(rooms[edges[edge].x].getMidpoint()), Vector2(rooms[edges[edge].y].getMidpoint())]
				#Checks is the currentEdge intersects with one of the previous eges.
				if(Math.linesIntersect(currentEdge, previousEdge)):
					intersects = true
					break
			#If no intersections were found, add to edges array.
			if(!intersects): 
				edges.append(Vector2(currentRoom, previousRoom))
	return edges
#Finds the minimum spanning tree(MST) of edges.
func initMST(edges):
	var mstEdges = []
	var sets = []
	var copy = [] + edges
	#Insertion sorts by distance smallest to largest.
	var i = 1
	while(i < copy[1].size()):
		var j = i
		while(j > 0 && copy[1][j - 1] > copy[1][j]):
			#Swapping.
			var temp = copy[0][j - 1]
			copy[0][j - 1] = copy[0][j]
			copy[0][j] = temp
			temp = copy[1][j - 1]
			copy[1][j - 1] = copy[1][j]
			copy[1][j] = temp
			j -= 1
		i += 1
	#Sorted edges array.
	var sortedEdges = copy[0]
	#Adds the first(smallest) edge to the MST and creates the first set.
	mstEdges.append(sortedEdges[0])
	sets.append([sortedEdges[0]])
	#Connection variables.
	var loops = false
	var connected = Vector2(0, 0)
	var connectedSets = []
	#For every edge.
	for index in range(1, sortedEdges.size()):
		var currentEdge = sortedEdges[index]
		#Resets values.
		loops = false
		connectedSets = []
		#For every set of connected edges.
		for setIndex in range(sets.size()):
			#Resets values.
			connected = Vector2(0, 0)
			#For every edge in the set.
			for element in sets[setIndex]:
				#If the first room of the currentEdge is connected to the set tree, save the set index.
				if(connected.x == 0 && (element.x == currentEdge.x || element.y == currentEdge.x)):
					connected.x = 1
					connectedSets.append(setIndex)
				#If the second room of the currentEdge is connected to the set tree, save the set index.
				if(connected.y == 0 && (element.x == currentEdge.y || element.y == currentEdge.y)):
					connected.y = 1
					connectedSets.append(setIndex)
				#If both rooms of currentEdge are connected to the tree - it creates a loop - break.
				if(connected == Vector2(1, 1)): 
					loops = true
					break
		#If loops don't add the currentEdge else:
		if(!loops):
			#If currentEdge is connected to only one set tree - add it to the set.
			if(connectedSets.size() == 1): sets[connectedSets[0]].append(currentEdge)
			#If currentEdge is connected to more than one tree(2) - add to set and merge sets.
			elif(connectedSets.size() > 1): 
				sets[connectedSets[0]].append(currentEdge)
				sets[connectedSets[0]] += sets[connectedSets[1]]
				sets.remove(connectedSets[1])
			#If currentEdge isn't connected to any set trees - it's isolated - create it's own set.
			else:
				sets.append([currentEdge])
	#Add all the edges to the MST array. 
	for setIndex in range(sets.size()):
		for element in sets[setIndex]:
			mstEdges.append(element)
	return mstEdges	