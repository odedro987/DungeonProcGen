extends Node2D

const ROOM_COUNT = 10
const TILE_SIZE = 8
const ROOM_SIZE_RANGE = Vector2(8 * 6, 8 * 12)
const DUNGEON_RADIUS = 300
var rooms
var edges
var mstEdges
var drawIndex = 0

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
	rooms = []
	generateRooms()
	edges = [Calculations.triangulateRooms(rooms), []]
	for edge in range(edges[0].size()):
		var diff = rooms[edges[0][edge].x].getMidpoint() - rooms[edges[0][edge].y].getMidpoint()
		edges[1].append(sqrt(pow(diff.y, 2) + pow(diff.x, 2)))
	mstEdges = Calculations.initMST(edges)
	_draw()
	#set_process_input(true)
	#edges = [Calculations.triangulateSweepHull(rooms)]

func generateRooms():
	for i in range(ROOM_COUNT):
		var newRoom = Rect2(Math.getRandomPointInCircle(DUNGEON_RADIUS, TILE_SIZE), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
		while(Calculations.roomCollidesInArray(newRoom, rooms)):
			newRoom = Rect2(Math.getRandomPointInCircle(DUNGEON_RADIUS, TILE_SIZE), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
		var dungeonRoom = DungeonRoom.new()
		dungeonRoom.init(i, newRoom)
		rooms.append(dungeonRoom)

func generateCorridors():
	for mstEdge in range(mstEdges.size()):
		var room1 = rooms[mstEdges[mstEdge].x]
		var room2 = rooms[mstEdges[mstEdge].y]
		var diffX = Vector2(room1.getRect().pos.x, room1.getRect().end.x) - Vector2(room2.getRect().pos.x, room2.getRect().end.x)
		var diffY = Vector2(room1.getRect().pos.y, room1.getRect().end.y) - Vector2(room2.getRect().pos.y, room2.getRect().end.y)

func _input(event):
	if(event.is_action_pressed("ui_accept")): 
		drawIndex += 1 if drawIndex < (rooms.size() + edges[0].size() + mstEdges.size()) else 0
		update()

func _draw():
	#for i in range(drawIndex):
	#	if(i < rooms.size()):
	#		draw_rect(rooms[i].getRect(), Color(0, 0, 0))
	#	elif(i - rooms.size() < edges[0].size()):
	#		draw_line(rooms[edges[0][i - rooms.size()].x].getMidpoint(), rooms[edges[0][i - rooms.size()].y].getMidpoint(), Color(255, 0, 0))
	#	else:
	#		draw_line(rooms[mstEdges[i - rooms.size() - edges[0].size()].x].getMidpoint(), rooms[mstEdges[i - rooms.size() - edges[0].size()].y].getMidpoint(), Color(0, 255, 0), 2)
	
	for room in rooms:
		draw_rect(room.getRect(), Color(0, 0, 0))
	for edge in range(edges[0].size()):
		draw_line(rooms[edges[0][edge].x].getMidpoint(), rooms[edges[0][edge].y].getMidpoint(), Color(255, 0, 0))
	for mstEdge in range(mstEdges.size()):
		draw_line(rooms[mstEdges[mstEdge].x].getMidpoint(), rooms[mstEdges[mstEdge].y].getMidpoint(), Color(0, 255, 0), 2)