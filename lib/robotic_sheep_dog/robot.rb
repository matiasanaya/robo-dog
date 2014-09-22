module RoboticSheepDog
  class Robot
    def initialize(args = {})
      @pose = args[:pose]
      @commands = args[:commands] || []
      @coordinator = args[:coordinator]
    end

    def execute(mode)
      case mode
      when :all
        commands.map! do |command|
          self.send(command)
          nil
        end
        commands.compact!
      when :next
        self.send(commands.shift)
      end
    end

    def report
      pose.report
    end

    def coordinates
      pose.coordinates
    end

    def move
      adj_pose = pose.adjacent
      self.pose = adj_pose if coordinator.valid_coordinates?(adj_pose)
      nil
    end

    def right
      pose.rotate!(:clockwise)
      nil
    end

    def left
      pose.rotate!(:counter)
      nil
    end

    private

    attr_reader :commands, :coordinator
    attr_accessor :pose
  end
end
