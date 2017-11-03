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
#Triangulates rooms with sets and heaps.
func triangulateRoomSets(rooms):
	var edges = []
	var biggest  = Utils.heapSort(rooms, Utils.SiftType.BIGGEST)
	var smallest = Utils.heapSort(rooms, Utils.SiftType.SMALLEST)
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
	var times = 0
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
				times += 1
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
	
	#Insertion sorts by distance smallest to largest.
	var i = 1
	while(i < edges[1].size()):
		var j = i
		while(j > 0 && edges[1][j - 1] > edges[1][j]):
			#Swapping the midpoints.
			var temp = edges[0][j - 1]
			edges[0][j - 1] = edges[0][j]
			edges[0][j] = temp
			temp = edges[1][j - 1]
			edges[1][j - 1] = edges[1][j]
			edges[1][j] = temp
			j -= 1
		i += 1
	
	var sortedEdges = edges[0]
	
	mstEdges.append(sortedEdges[0])
	sets.append([sortedEdges[0]])
	
	var loops = false
	var connectedX = false
	var connectedY = false
	var connectedSets = []
	print(sortedEdges)
	for index in range(1, sortedEdges.size()):
		var currentEdge = sortedEdges[index]
		print(currentEdge)
		loops = false
		connectedSets = []
		for setIndex in range(sets.size()):
			connectedX = false
			connectedY = false
			for element in sets[setIndex]:
				if(!connectedX && (element.x == currentEdge.x || element.y == currentEdge.x)):
					connectedX = true
					connectedSets.append(setIndex)
				if(!connectedY && (element.x == currentEdge.y || element.y == currentEdge.y)):
					connectedY = true
					connectedSets.append(setIndex)
				if(connectedY && connectedX): 
					loops = true
					break
		if(!loops):
			if(connectedSets.size() == 1): sets[connectedSets[0]].append(currentEdge)
			elif(connectedSets.size() > 1): 
				sets[connectedSets[0]].append(currentEdge)
				sets[connectedSets[0]] += sets[connectedSets[1]]
				sets.remove(connectedSets[1])
			else:
				sets.append([currentEdge])
		print(sets)
	
	for setIndex in range(sets.size()):
		for element in sets[setIndex]:
			mstEdges.append(element)
	return mstEdges	