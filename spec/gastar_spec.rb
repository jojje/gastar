require_relative '../lib/gastar'

class Node < AStarNode
  attr_reader :name, :x, :y
  def initialize(name, x, y)
    super()
    @name, @x, @y = name, x, y
  end
  def move_cost(other) 1 end
  def to_s() name end
end

class Space < AStar
  def heuristic(node, start, goal)
    Math.sqrt( (goal.x - node.x)**2 + (goal.y - node.y)**2 )
  end
end

describe "AStar implementation" do

  it "finds the shorted path between cities" do

    sun = Node.new "Sundsvall",  9, 10
    upp = Node.new "Uppsala",    9,  6
    sth = Node.new "Stockholm", 10,  5
    jon = Node.new "Jonkoping",  4,  3
    got = Node.new "Gothenburg", 1,  3
    mal = Node.new "Malmo",      2,  1

    cities = {
      sun => [upp],
      sth => [sun,jon,upp],
      jon => [sth,got,mal],
      upp => [sth,sun],
      mal => [jon],
      got => [jon]
    }

    expected = [sun, upp, sth, jon, mal]
    actual   = Space.new(cities).search(sun, mal)

    actual.should eql(expected)

  end
end
  