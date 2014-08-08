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

    expect(actual).to eql(expected)

  end

  it "finds the longest path between cities" do

    a = Node.new "C1",  1, 1
    b = Node.new "C2",  2, 2
    c = Node.new "C3",  1, 3
    d = Node.new "C4",  1, 4


    cities = {
      a => [b,c],
      b => [c],
      c => [d],
      d => [c],
    }

    expect( Space.new(cities, false).search(a, d) ).to eql([a,c,d])
    expect( Space.new(cities, true ).search(a, d) ).to eql([a,b,c,d])

  end

end
