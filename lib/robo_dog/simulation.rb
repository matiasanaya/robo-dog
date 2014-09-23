module RoboDog
  class Simulation
    def initialize(args = {})
      @paddock = args[:paddock]
      @robots = args[:robots] || []
    end

    def run(mode = :sequential)
      warm_up
      case mode
      when :sequential
        robots.each { |r| r.execute(:all) }
      when :turns
        run_in_turns
      end
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
        'Invalid coordinates. This means two '\
        'robots collided or one of them did '\
        'with the border of the paddock.'\
        "#{robots.inspect}"
      )
    end

    def run_in_turns
      loop do
        executed = false
        robots.each do |r|
          _ = r.execute(:next)
          executed ||= _
        end
        break unless executed
      end
    end
  end
end
