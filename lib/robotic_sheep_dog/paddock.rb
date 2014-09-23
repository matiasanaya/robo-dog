module RoboticSheepDog
  class Paddock

    DataError = Class.new(StandardError)

    def self.build(string)
      raise DataError unless validate(string)

      x, y = string.split(' ').map(&:to_i)

      new(x, y)
    end

    def initialize(x_size = 1, y_size = 1)
      @x_size = x_size
      @y_size = y_size
    end

    def valid_coordinates?(coordinates)
      coordinates && (0..x_size).include?(coordinates[:x]) && (0..y_size).include?(coordinates[:y])
    end

    private

    attr_reader :x_size, :y_size

    def self.validate(string)
      string =~ /\A\d+ \d+\z/
    end
  end
end
