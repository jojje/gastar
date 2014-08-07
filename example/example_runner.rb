require_relative "../lib/gastar"

##########################################################
# Example implementations
##########################################################

class AStarGrid < AStar
  def heuristic(node, start, goal)
    Math.sqrt((goal.x - node.x)**2 + (goal.y - node.y)**2)
  end
end

class AStarGridNode < AStarNode
  attr_reader :x, :y
  def initialize(x, y)
    super()
    @x, @y = x, y
  end
  def move_cost(other)
    diagonal = (self.x - other.x).abs == 1 and (self.y - other.y).abs == 1
    diagonal ? 14 : 10
  end
  def to_s
    "(%d,%d)" % [x,y]
  end
end

##########################################################
# Example graph generator and use of the search algoritm
##########################################################

def make_graph(width, height)
  nodes = width.times.map{|x| height.times.map{|y| AStarGridNode.new(x, y) } }
  graph = {}
  width.times.to_a.product(height.times.to_a).each do |x, y|
    node = nodes[x][y]
    graph[node] = []
    [-1, 0, 1].product([-1, 0, 1]).each do |i, j|
      next unless 0 <= x + i && x + i < width
      next unless 0 <= y + j && y + j < height
      graph[nodes[x][y]] << nodes[x+i][y+j]
    end
  end
  [graph, nodes]
end

def render(width,height,start, goal, path)
  vertices = path.map{|step| [step.x, step.y] }
  height.times.each do |y|
    width.times.each do |x|
      if [start.x, start.y] == [x,y]
        print "S"
      elsif [goal.x, goal.y] == [x,y]
        print "G"
      elsif vertices.include?([x,y])
        print "+"
      else
        print "."
      end
    end
    puts
  end
end

def main
  width, height = 16,10
  graph, nodes = make_graph(width, height)
  paths = AStarGrid.new(graph)
  start, goal = nodes[1][2], nodes[ 12][7]
  path = paths.search(start, goal)
  unless path
    puts "No path found"
  else
    puts "Path found:", path.join(" ")
    render(width,height,start, goal, path)
  end
end

main if __FILE__ == $0  
