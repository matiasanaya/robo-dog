require_relative 'pose/orientation'

module RoboticSheepDog
  class Pose
    DataError = Class.new(StandardError)

    def self.build(string)
      raise DataError unless validate(string)

      new(parse(string))
    end

    def initialize(args = {})
      @x = args[:x] || 0
      @y = args[:y] || 0
      @orientation = args[:orientation] || Orientation::NORTH
    end

    def report
      coordinates.merge(orientation: Orientation.stringify(orientation))
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

    def self.validate(string)
      string =~ /\A\d+ \d+ [NSWE]\z/
    end

    def self.parse(string)
      x_str, y_str, orientation_str = string.split(' ')
      x, y = x_str.to_i, y_str.to_i
      orientation = Orientation.constantize(orientation_str)

      {
        x: x,
        y: y,
        orientation: orientation
      }
    end

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
