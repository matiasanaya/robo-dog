module RoboticSheepDog
  class Simulation
    def initialize(args = {})
      @paddock = args[:paddock]
      @robots = args[:robots] || []
    end

    def run
      warm_up
      robots.each { |r| r.execute(:all) }
      true
    end

    def report
      {
        robots: robots.map { |r| r.report }
      }
    end

    def valid_coordinates?(coordinates)
      coordinates &&
      paddock.valid_coordinates?(coordinates) &&
      robots.all? { |r| r.coordinates != coordinates } ||
      fail_appropriately
    end

    private

    attr_reader :robots, :paddock

    def warm_up
      fail_appropriately if robots.dup.uniq! { |r| r.coordinates }
      robots.each { |r| r.add_coordinator(self) }
    end

    def fail_appropriately
      fail(
        'Invalid coordinates. This means robots'\
        'collided with themselves or the border'\
        'of the paddock.'
      )
    end
  end
end
