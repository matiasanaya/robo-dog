module RoboticSheepDog
  class Simulation
    def initialize(args = {})
      @paddock = args[:paddock]
      @robots = args[:robots] || []
    end

    def run
      robots.each { |r| r.execute(:all) }
      true
    end

    def report
      {
        robots: robots.map { |r| r.report }
      }
    end

    def valid_coordinates?(coordinates)
      coordinates && paddock.valid_coordinates?(coordinates) && robots.all? { |r| r.coordinates != coordinates }
    end

    private

    attr_reader :robots, :paddock
  end
end
