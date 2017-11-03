extends Node

func _ready():
	pass

enum HeapNode { PARENT, LEFT_CHILD, RIGHT_CHILD }
enum SiftType { SMALLEST, BIGGEST }
#Returns the corresponding heap node of index.
func getHeapNode(index, heapNode):
	if(heapNode == HeapNode.PARENT):
		return floor((index - 1) / 2)
	elif (heapNode == HeapNode.LEFT_CHILD):
		return 2 * index + 1
	elif (heapNode == HeapNode.RIGHT_CHILD):
		return 2 * index + 2
	else:
		 return -1
#Heap sorts an array by type.
func heapSort(array, type):
	#Copies the array.
	var sorted = [] + array
	heapify(sorted, type)
	var end = sorted.size() - 1
	while(end > 0):
		var temp = sorted[end]
		sorted[end] = sorted[0]
		sorted[0] = temp
		end -= 1
		siftDown(sorted, 0, end, type)
	return sorted
#Repairs the heap.
func siftDown(array, start, end, type):
	#Sets root as start.
	var root = start
	#While there's a left child.
	while(getHeapNode(root, HeapNode.LEFT_CHILD) <= end):
		var child = getHeapNode(root, HeapNode.LEFT_CHILD)
		var swap = root
		var leftSwap = array[swap].getMidpoint().y < array[child].getMidpoint().y if type == SiftType.SMALLEST else array[swap].getMidpoint().y > array[child].getMidpoint().y
		#If the left child is bigger/smaller than the root.
		if(leftSwap):
			swap = child
		var rightSwap = array[swap].getMidpoint().y < array[child + 1].getMidpoint().y if type == SiftType.SMALLEST else array[swap].getMidpoint().y > array[child + 1].getMidpoint().y
		#If the right child is bigger/smaller than the left child.
		if(child + 1 <= end && rightSwap):
			swap = child + 1
		#If swap isn't root, meaning they should swap.
		if(swap != root):
			var temp = array[root]
			array[root] = array[swap]
			array[swap] = temp
			root = swap
		else:
			break
#Puts the elements of array in heap order.
func heapify(array, type):
	var start = getHeapNode(array.size() - 1, HeapNode.PARENT)
	while(start >= 0):
		siftDown(array, start, array.size() - 2, type)
		start -= 1
#Heap sorts an array by type.
func heapSortEdges(array, type):
	heapify(array, type)
	var end = array[0].size() - 1
	while(end > 0):
		var temp = array[0][end]
		array[0][end] = array[0][0]
		array[0][0] = temp
		temp = array[1][end]
		array[1][end] = array[1][0]
		array[1][0] = temp
		end -= 1
		siftDownEdges(array, 0, end, type)
#Repairs the heap.
func siftDownEdges(array, start, end, type):
	#Sets root as start.
	var root = start
	#While there's a left child.
	while(getHeapNode(root, HeapNode.LEFT_CHILD) <= end):
		var child = getHeapNode(root, HeapNode.LEFT_CHILD)
		var swap = root
		var leftSwap = array[1][swap] < array[1][child] if type == SiftType.SMALLEST else array[1][swap] > array[1][child]
		#If the left child is bigger/smaller than the root.
		if(leftSwap):
			swap = child
		var rightSwap = array[1][swap] < array[1][child + 1] if type == SiftType.SMALLEST else array[1][swap] > array[1][child + 1]
		#If the right child is bigger/smaller than the left child.
		if(child + 1 <= end && rightSwap):
			swap = child + 1
		#If swap isn't root, meaning they should swap.
		if(swap != root):
			var temp = array[0][root]
			array[0][root] = array[0][swap]
			array[0][swap] = temp
			temp = array[1][root]
			array[1][root] = array[1][swap]
			array[1][swap] = temp
			root = swap
		else:
			break
#Puts the elements of array in heap order.
func heapifyEdges(array, type):
	var start = getHeapNode(array[0].size() - 1, HeapNode.PARENT)
	while(start >= 0):
		siftDownEdges(array, start, array[0].size() - 2, type)
		start -= 1