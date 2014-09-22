module RoboticSheepDog
  class Pose
    module Orientation
      NORTH = :north
      EAST = :east
      SOUTH = :south
      WEST = :west
    end

    def initialize(args = {})
      @x = args[:x] || 0
      @y = args[:y] || 0
      @orientation = args[:orientation] || Orientation::NORTH
    end

    def report
      coordinates.merge(orientation: orientation)
    end

    def coordinates
      {x: x, y: y}
    end

    def adjacent
      dup.send(:adjacent!)
    end

    def rotate!(direction = :clockwise)
      self.orientation = next_orientation(direction)
      self
    end

    private

    attr_accessor :x, :y, :orientation

    def next_orientation(direction)
      by = direction == :clockwise ? 1 : -1

      orientations = [
        Orientation::NORTH,
        Orientation::EAST,
        Orientation::SOUTH,
        Orientation::WEST
      ]

      orientations[(orientations.index(orientation) + by) % 4]
    end

    def adjacent!
      case orientation
      when Orientation::EAST
        increment!(:x)
      when Orientation::NORTH
        increment!(:y)
      when Orientation::WEST
        decrement!(:x)
      when Orientation::SOUTH
        decrement!(:y)
      end
      self
    end

    def increment!(coordinate)
      update_coordinate!(coordinate, 1)
    end

    def decrement!(coordinate)
      update_coordinate!(coordinate, -1)
    end

    def update_coordinate!(coordinate, by = 1)
      self.send("#{coordinate}=", self.send(coordinate) + by)
    end
  end
end
