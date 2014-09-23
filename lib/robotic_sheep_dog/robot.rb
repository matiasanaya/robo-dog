require_relative 'pose'

module RoboticSheepDog
  class Robot

    DataError = Class.new(StandardError)

    def self.build(attrs)
      raise DataError unless validate(attrs[:commands])

      pose = Pose.build(attrs[:pose])
      commands = lex(attrs[:commands])

      new(pose: pose, commands: commands)
    end

    def initialize(args = {})
      @pose = args[:pose]
      @commands = args[:commands] || []
      @coordinators = args[:coordinators] || []
    end

    def add_coordinator(coordinator)
      coordinators << coordinator
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
        command = commands.shift
        if command
          self.send(command)
          true
        else
          false
        end
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
      self.pose = adj_pose if coordinators.all? { |c| c.valid_coordinates?(adj_pose.coordinates) }
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

    attr_reader :commands, :coordinators
    attr_accessor :pose

    def self.validate(string)
      string =~ /\A[MLR]*\z/
    end

    def self.lex(commands_string)
      commands_string.chars.map do |char|
        case char
        when 'M'
          :move
        when 'R'
          :right
        when 'L'
          :left
        end
      end
    end
  end
end
