require "set"
require_relative "gastar/version"

# A generic implementation of the A* search algoritm.
#
# A* is a search algoritm and this is a ruby implementation of it.
# The implementation is such that you wrap the objects you want to find
# paths between, add them to a Hash where the keys are nodes and values
# neighbours of the corresponding nodes. You then provide this graph (hash)
# when you instantiate the +AStar+ search class.
#
# To find the shortest path, or most profitable between two nodes, you supply
# the start and goal nodes to the +#search+ method and if a path can be found
# a list of the nodes making up the journey will be provided back. If no path
# can be found, nil is returned.
#
# For implementation examples, refer to the rspec and test runner in the spec
# directory.
#
# Credits:
# The gem is mostly a rubification of Justin Poliey's Python implementation.
# Check out his excellent post on the subject at:
#  http://scriptogr.am/jdp/post/pathfinding-with-python-graphs-and-a-star
#

class AStar
  # Populate the search space and indicate whether searching should maximize
  # estimated cost for moving between nodes, or whether it should be
  # minimized.
  #
  # Arguments:
  # +graph+ is a the search space on which the path finding should operate.
  # It's a plain hash with AStar nodes as keys and also for neighbor as the
  # values. The value of each hash entry should be a list of neighbors.
  # E.g. {node => [neighbour node, neighbour node]}
  #
  # +maximize_cost+ indicates that higher heuristic values and costs are better,
  # such as higher profits. Normally it's less that's desired, for example for
  # distance routing in euclidean space. This an optional argument and the
  # default is to minimize cost (false).
  #
  def initialize(graph, maximize_cost=false)
    @graph = graph
    @maximize_cost = maximize_cost
  end

  # Abstract method that an implementor must provide in a derived class.
  # This function should return the estimated cost (a number) for getting to
  # the goal node. In eucledian space (2D/3D), most likely the trigonometric
  # distance (Pythagorean theorem). For other uses some other function may be
  # appropriate.
  #
  # Arguments:
  # +node+  is the current node for which cost to the goal should be estimated.
  # +start+ is the starting node. May or may not be useful to you, but is
  #         provided all the same.
  # +goal+  is the final destination node towards which the distance / cost
  # should be estimated.
  def heuristic(node, start, goal)
    raise NotImplementedError
  end

  # Performs the actual path-finding. Takes two AStarNodes. 
  # +start+, is the origin for the search and +goal+ where we want to get to.
  # Returns the nodes (steps) including the start and goal nodes, that should
  # be traversed if we were to follow the path.
  def search(start, goal)
    openset = Set.new
    closedset = Set.new
    current = start
    openset_min_max = @maximize_cost ? openset.method(:max_by) : openset.method(:min_by)

    openset.add(current)
    while not openset.empty?
      current = openset_min_max.call{|o| o.g + o.h }
      if current == goal
        path = []
        while current.parent
          path << current
          current = current.parent
        end
        path << current
        return path.reverse
      end
      openset.delete(current)
      closedset.add(current)
      @graph[current].each do |node|
        next if closedset.include? node

        if openset.include? node
          new_g = current.g + current.move_cost(node)
          if node.g > new_g
            node.g = new_g
            node.parent = current
          end
        else
          node.g = current.g + current.move_cost(node)
          node.h = heuristic(node, start, goal)
          node.parent = current
          openset.add(node)
        end
      end
    end
    return nil
  end

end

# Abstract class where you implement the move_cost function
# which specifies how expensive it is to get from the
# current node to the +other+ node.
class AStarNode
  attr_accessor :g, :h, :parent
  def initialize
    @g, @h, @parent = 0, 0, nil
  end
  def move_cost(other)
    raise NotImplementedError
  end
end
