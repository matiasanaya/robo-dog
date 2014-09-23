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

    def run(mode = nil)
      simulation_attrs = parser.parse(input)
      simulation = simulation_class.new(simulation_attrs)

      simulation.run(mode)
      puts format(simulation.report)
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
