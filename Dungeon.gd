extends Node2D

const ROOM_COUNT = 20
const TILE_SIZE = 8
const ROOM_SIZE_RANGE = Vector2(8 * 6, 8 * 12)
const DUNGEON_RADIUS = 300
const CORRIDOR_WIDTH = 8 * 2
const SHOW_TRIANGULATION = true
const SHOW_MST = false
var rooms
var edges
var mstEdges
var drawIndex = 0

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
	rooms = []
	generateRooms()
	edges = [Calculations.triangulateRooms(rooms, DUNGEON_RADIUS), []]
	for edge in range(edges[0].size()):
		var diff = rooms[edges[0][edge].x].getMidpoint() - rooms[edges[0][edge].y].getMidpoint()
		edges[1].append(sqrt(pow(diff.y, 2) + pow(diff.x, 2)))
	mstEdges = Calculations.initMST(edges)
func generateRooms():
	for i in range(ROOM_COUNT):
		var newRoom = null
		while(newRoom == null || Calculations.roomCollidesInArray(newRoom, rooms)):
			var randomWidth = int(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)))
			var randomHeight = int(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)))
			newRoom = Rect2(Math.getRandomPointInCircle(DUNGEON_RADIUS, TILE_SIZE), Vector2(randomWidth - randomWidth % TILE_SIZE, randomHeight - randomHeight % TILE_SIZE))
		var dungeonRoom = DungeonRoom.new()
		dungeonRoom.init(i, newRoom)
		rooms.append(dungeonRoom)
func _draw():
	for room in rooms:
		draw_rect(room.getRect(), Color(0, 0, 0))
	for mstEdge in range(mstEdges.size()):
		#Rooms rects vars.
		var room1 = rooms[mstEdges[mstEdge].x].getRect()
		var room2 = rooms[mstEdges[mstEdge].y].getRect()
		#Put higher room first.
		if(room2.pos.y < room1.pos.y):
			var temp = room1
			room1 = room2
			room2 = temp
		#Calculate differences
		var diffX = Vector2(room1.pos.x, room1.end.x) - Vector2(room2.pos.x, room2.end.x)
		if(diffX.x <= 0):
			if(room1.end.x - room2.pos.x > CORRIDOR_WIDTH):
				var randomX = int(rand_range(room2.pos.x, room1.end.x - CORRIDOR_WIDTH)) if room1.end.x < room2.end.x else int(rand_range(room2.pos.x, room2.end.x - CORRIDOR_WIDTH))
				draw_rect(Rect2(randomX - randomX % TILE_SIZE, room1.end.y, CORRIDOR_WIDTH, room2.pos.y - room1.end.y), Color(0,0,0))
		elif(diffX.x > 0):
			if(room2.end.x - room1.pos.x > CORRIDOR_WIDTH):
				var randomX = int(rand_range(room1.pos.x, room2.end.x - CORRIDOR_WIDTH)) if room2.end.x < room1.end.x else int(rand_range(room1.pos.x, room1.end.x - CORRIDOR_WIDTH))
				draw_rect(Rect2(randomX - randomX % TILE_SIZE, room1.end.y, CORRIDOR_WIDTH, room2.pos.y - room1.end.y), Color(0,0,0))
		#Put further to the right first.
		if(room2.pos.x < room1.pos.x):
			var temp = room1
			room1 = room2
			room2 = temp
		#Calculate differences
		var diffY = Vector2(room1.pos.y, room1.end.y) - Vector2(room2.pos.y, room2.end.y)
		if(diffY.x <= 0):
			if(room1.end.y - room2.pos.y > CORRIDOR_WIDTH):
				var randomY = int(rand_range(room2.pos.y, room1.end.y - CORRIDOR_WIDTH)) if room1.end.y < room2.end.y else int(rand_range(room2.pos.y, room2.end.y - CORRIDOR_WIDTH))
				draw_rect(Rect2(room1.end.x, randomY - randomY % TILE_SIZE, room2.pos.x - room1.end.x, CORRIDOR_WIDTH), Color(0,0,0))
		elif(diffY.x > 0):
			if(room2.end.y - room1.pos.y > CORRIDOR_WIDTH):
				var randomY = int(rand_range(room1.pos.y, room2.end.y - CORRIDOR_WIDTH)) if room2.end.y < room1.end.y else int(rand_range(room1.pos.y, room1.end.y - CORRIDOR_WIDTH))
				draw_rect(Rect2(room1.end.x, randomY - randomY % TILE_SIZE, room2.pos.x - room1.end.x, CORRIDOR_WIDTH), Color(0,0,0))
	if(SHOW_TRIANGULATION):
		for edge in range(edges[0].size()):
			draw_line(rooms[edges[0][edge].x].getMidpoint(), rooms[edges[0][edge].y].getMidpoint(), Color(255, 0, 0))
	if(SHOW_MST):
		for mstEdge in range(mstEdges.size()):
			draw_line(rooms[mstEdges[mstEdge].x].getMidpoint(), rooms[mstEdges[mstEdge].y].getMidpoint(), Color(0, 255, 0), 2)