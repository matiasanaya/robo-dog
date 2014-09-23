module RoboticSheepDog
  class Pose
    module Orientation
      NORTH = :north
      EAST = :east
      SOUTH = :south
      WEST = :west

      module_function

      def constantize(string)
        case string
        when 'N'
          NORTH
        when 'E'
          EAST
        when 'S'
          SOUTH
        when 'W'
          WEST
        end
      end

      def stringify(orientation)
        case orientation
        when NORTH
          'N'
        when EAST
          'E'
        when SOUTH
          'S'
        when WEST
          'W'
        end
      end
    end
  end
end
