module RoboticSheepDog
  class Paddock
    def initialize(x_size = 1, y_size = 1)
      @x_size = x_size
      @y_size = y_size
    end

    def valid_coordinates?(coordinates)
      coordinates && (0..x_size).include?(coordinates[:x]) && (0..y_size).include?(coordinates[:y])
    end

    private

    attr_reader :x_size, :y_size
  end
end
