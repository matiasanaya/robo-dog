module RoboticSheepDog
  module Parser
    DataError = Class.new(StandardError)

    @validator = -> (data, regex) { raise DataError unless data =~ regex }

    @extractor = lambda do |input, regex|
      extracted = input.gets
      if extracted
        extracted.chomp!
        @validator.call(extracted, regex)
      end
      extracted
    end

    @robot_data_parser = lambda do |input|
      pose = @extractor.call(input, /\A\d+ \d+ [NSWE]\z/)
      commands = @extractor.call(input, /\A[MLR]*\z/)

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
      paddock = @extractor.call(input, /\A\d+ \d+\z/)
      robots = []
      loop do
        robot = @robot_data_parser.call(input)
        break unless robot
        robots << robot
      end

      {
        paddock: paddock,
        robots: robots
      }
    end
  end
end
