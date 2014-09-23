require_relative 'parser'
require_relative 'simulation'

module RoboticSheepDog
  class Application
    def self.build(input = nil)
      new(input: input, parser: Parser, simulation_class: Simulation)
    end

    def initialize(args = {})
      @input = args[:input] || $stdin
      @parser = args[:parser]
      @simulation_class = args[:simulation_class]
    end

    def run
      s = simulation_class.new(
        parser.parse(
          input
        )
      )

      s.run

      puts format(s.report)
    end

    private

    attr_reader :input, :parser, :simulation_class

    def format(report)
      str = ''
      report[:robots].each do |r|
        str << "#{r[:x]} #{r[:y]} #{r[:orientation]}"
        str << "\n"
      end
      str
    end
  end
end
