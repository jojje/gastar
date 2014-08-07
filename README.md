# Gastar

Generic A* (A-Star) search implementation for Ruby

It is more or less a straight Ruby implementation of Justin Poliey's Python
implementation. 

To read more about the fine algoritm for finding the shortest path between
nodes (cities, trade stops etc), read Justin's [blog post]
(http://scriptogr.am/jdp/post/pathfinding-with-python-graphs-and-a-star)
on the matter and check out the rather fine [Wikipedia article]
(http://en.wikipedia.org/wiki/A*_search_algorithm).

## Installation

Add this line to your application's Gemfile:

    gem 'gastar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gastar

## Usage

Example use:

    require 'gastar'
    
    # Implement the abstract node class.
    # Note: All attributes below are custom for this implementation and none are
    # needed nor used by the actual AStar seach algorithm. They're my domain atts.
    class Node < AStarNode
      attr_reader :name, :x, :y
      def initialize(name, x, y)
        super()
        @name, @x, @y = name, x, y
      end
      def move_cost(other) 1 end
      def to_s() name end
    end
    
    # Also implement an algorithm for estimating cost of reaching the destination
    class Space < AStar
      def heuristic(node, start, goal)
        Math.sqrt( (goal.x - node.x)**2 + (goal.y - node.y)**2 )
      end
    end
    
    # Create a graph as an ordinary hashmap, with the key being a node and the
    # value a list of other nodes that can be reached from the key-node.
    
    sun = Node.new "Sundsvall",  9, 10
    upp = Node.new "Uppsala",    9,  6
    sth = Node.new "Stockholm", 10,  5
    jon = Node.new "Jonkoping",  4,  3
    got = Node.new "Goteborg",   1,  3
    mal = Node.new "Malmo",      2,  1
  
    cities = {
      sun => [upp],
      sth => [sun,jon,upp],
      jon => [sth,got,mal],
      upp => [sth,sun],
      mal => [jon],
      got => [jon]
    }
  
    puts Space.new(cities).search(sun, mal)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
