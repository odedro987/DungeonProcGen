extends Node2D

const ROOM_COUNT = 15
const ROOM_SIZE_RANGE = Vector2(20, 70)
const DUNGEON_RADIUS = 200
var rooms
var edges
var mstEdges

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

func generateRooms():
	for i in range(ROOM_COUNT):
		var newRoom = Rect2(Math.getRandomPointInCircle(DUNGEON_RADIUS), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
		while(Calculations.roomCollidesInArray(newRoom, rooms)):
			newRoom = Rect2(Math.getRandomPointInCircle(DUNGEON_RADIUS), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
		var dungeonRoom = DungeonRoom.new()
		dungeonRoom.init(i, newRoom)
		rooms.append(dungeonRoom)

func generateCorridors():
	pass

func _draw():
	for room in rooms:
		draw_rect(room.getRect(), Color(0, 0, 0))
	#for edge in range(edges[0].size()):
	#	draw_line(rooms[edges[0][edge].x].getMidpoint(), rooms[edges[0][edge].y].getMidpoint(), Color(255, 0, 0))
	for mstEdge in range(mstEdges.size()):
		draw_line(rooms[mstEdges[mstEdge].x].getMidpoint(), rooms[mstEdges[mstEdge].y].getMidpoint(), Color(0, 255, 0), 2)