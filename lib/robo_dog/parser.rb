require_relative 'paddock'
require_relative 'robot'

module RoboDog
  module Parser
    DataError = Class.new(StandardError)

    @paddock_factory = Paddock
    @robot_factory = Robot

    @extractor = -> (input) { e = input.gets and e.chomp }

    @paddock_parser = lambda do |input|
      paddock_attrs = @extractor.call(input)

      raise DataError unless paddock_attrs

      paddock = @paddock_factory.build(paddock_attrs)
    end

    @robot_extractor = lambda do |input|
      pose = @extractor.call(input)
      commands = @extractor.call(input)

      if pose && commands
        {
          pose: pose,
          commands: commands
        }
      else
        raise DataError unless pose.nil? && commands.nil?
        nil
      end
    end

    module_function

    def parse(input)
      paddock = @paddock_parser.call(input)
      robots = []
      loop do
        robot_attrs = @robot_extractor.call(input)
        break unless robot_attrs
        robots << @robot_factory.build(robot_attrs)
      end

      {
        paddock: paddock,
        robots: robots
      }
    end
  end
end
